import { createClient } from 'https://esm.sh/@supabase/supabase-js@2'
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

// Use your project URL and anon key here
const supabaseUrl = 'https://xdzepwgrzealmgdmfigl.supabase.co'
const supabaseAnonKey = 'YOUR_ANON_KEY'

serve(async (req) => {
  try {
    const { email } = await req.json()
    
    if (!email) {
      return new Response(
        JSON.stringify({ error: 'Email is required' }),
        { 
          status: 400, 
          headers: { 
            'Content-Type': 'application/json',
            "Access-Control-Allow-Origin": "*",
          } 
        }
      )
    }

    const supabase = createClient(supabaseUrl, supabaseAnonKey)

    // Get user from public.users
    const { data: userData, error: userError } = await supabase
      .from('users')
      .select('id, role')
      .eq('role', 'player')
      .single()

    if (userError || !userData) {
      return new Response(
        JSON.stringify({ error: 'User not found' }),
        { 
          status: 404, 
          headers: { 
            'Content-Type': 'application/json',
            "Access-Control-Allow-Origin": "*",
          } 
        }
      )
    }

    if (userData.role !== 'player') {
      return new Response(
        JSON.stringify({ error: 'User is not a player' }),
        { 
          status: 400, 
          headers: { 
            'Content-Type': 'application/json',
            "Access-Control-Allow-Origin": "*",
          } 
        }
      )
    }

    return new Response(
      JSON.stringify({ 
        user_id: userData.id,
        role: userData.role 
      }),
      { 
        status: 200, 
        headers: { 
          'Content-Type': 'application/json',
          "Access-Control-Allow-Origin": "*",
        } 
      }
    )

  } catch (error) {
    return new Response(
      JSON.stringify({ error: 'Internal server error' }),
      { 
        status: 500, 
        headers: { 
          'Content-Type': 'application/json',
          "Access-Control-Allow-Origin": "*",
        } 
      }
    )
  }
})