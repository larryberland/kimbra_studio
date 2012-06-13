# override for Machine in StateMachine gem.
# this is just a placeholder in case we really need to fix this gem.
# this code does fix the problem.  I think.


# Tracks the given set of states in the list of all known states for
# this machine
def add_states(new_states)
  new_states.map do |new_state|
    puts "#{new_state}: #{new_state.class}"
    # Check for other states that use a different class type for their name.
    # This typically prevents string / symbol misuse.
    if new_state &&
        conflict = states.detect do |state|
          state.name && state.name.class != new_state.class && state.name.class != StateMachine::AllMatcher && new_state.class != StateMachine::AllMatcher
        end
      raise ArgumentError, "#{new_state.inspect} state defined as #{new_state.class}, #{conflict.name.inspect} defined as #{conflict.name.class}; all states must be consistent"
    end

    unless state = states[new_state]
      states << state = State.new(self, new_state)

      # Copy states over to sibling machines
      sibling_machines.each {|machine| machine.states << state}
    end

    state
  end
end