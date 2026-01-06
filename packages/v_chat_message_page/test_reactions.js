// Simple test to verify reaction functionality
// This simulates the reaction toggle behavior

function testReactionToggle() {
    console.log('Testing Reaction Toggle Logic...\n');
    
    // Initial message state
    let message = {
        reactionNumber: 0,
        reactionSample: []
    };
    
    console.log('Initial state:', message);
    
    // User adds first emoji
    message = toggleReaction(message, '❤️');
    console.log('After adding ❤️:', message);
    
    // User adds second emoji  
    message = toggleReaction(message, '😂');
    console.log('After adding 😂:', message);
    
    // User adds third emoji
    message = toggleReaction(message, '👍');
    console.log('After adding 👍:', message);
    
    // User adds fourth emoji (should limit to 3 in sample)
    message = toggleReaction(message, '😮');
    console.log('After adding 😮:', message);
    
    // User removes existing emoji
    message = toggleReaction(message, '❤️');
    console.log('After removing ❤️:', message);
    
    // User adds emoji back
    message = toggleReaction(message, '❤️');
    console.log('After adding ❤️ back:', message);
}

function toggleReaction(message, emoji) {
    const currentSample = [...message.reactionSample];
    const currentNumber = message.reactionNumber;
    
    let updatedSample;
    let updatedNumber;
    
    if (currentSample.includes(emoji)) {
        // Remove emoji
        updatedSample = currentSample.filter(e => e !== emoji);
        updatedNumber = currentNumber > 0 ? currentNumber - 1 : 0;
    } else {
        // Add emoji
        updatedSample = [...currentSample, emoji];
        // Keep only top 3 unique emojis
        updatedSample = [...new Set(updatedSample)].slice(0, 3);
        updatedNumber = currentNumber + 1;
    }
    
    return {
        reactionNumber: updatedNumber,
        reactionSample: updatedSample
    };
}

// Run the test
testReactionToggle();
