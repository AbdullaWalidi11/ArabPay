// ==========================================
// THE BRAIN: Smart Routing Engine (Stage 2)
// ==========================================

export const evaluateRoute = (senderAccounts, receiverAccounts) => {
    if (!senderAccounts || senderAccounts.length === 0) {
        return { success: false, error: "Sender has no linked accounts." };
    }
    if (!receiverAccounts || receiverAccounts.length === 0) {
        return { success: false, error: "Receiver has no linked accounts." };
    }

    // Determine the receiver's primary currency (based on their preferred account)
    const receiverPreferred = receiverAccounts.find(acc => acc.isPreferred) || receiverAccounts[0];
    const targetCurrency = receiverPreferred.currency;

    // Analyze Sender Accounts and score them
    const analyzedSenderAccounts = senderAccounts.map(acc => {
        let isRecommended = false;
        let matchReason = "";

        // Simple Hackathon Logic: Recommend sender accounts that match the target currency
        if (acc.currency === targetCurrency) {
            isRecommended = true;
            matchReason = `Matches receiver's preferred currency (${targetCurrency}) to avoid FX fees.`;
        }

        return {
            ...acc, // Includes balance, provider, etc.
            isRecommended,
            matchReason
        };
    });

    // Sort so the recommended ones are at the top
    analyzedSenderAccounts.sort((a, b) => (b.isRecommended === true) - (a.isRecommended === true));

    // If none are recommended by currency match, just recommend the first one
    if (!analyzedSenderAccounts.find(a => a.isRecommended)) {
        analyzedSenderAccounts[0].isRecommended = true;
        analyzedSenderAccounts[0].matchReason = "Default funding source (FX fees may apply).";
    }

    return {
        success: true,
        receiverTarget: receiverPreferred, // Who we are sending to
        senderOptions: analyzedSenderAccounts // The options for the sender to pick from (with balances!)
    };
};