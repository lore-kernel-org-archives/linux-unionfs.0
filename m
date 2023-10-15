Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1AD72CDB47E
	for <linux-unionfs@archiver.kernel.org>; Sun, 15 Oct 2023 16:24:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230451AbjJOQYa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 15 Oct 2023 12:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231253AbjJOQY0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 15 Oct 2023 12:24:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C775AD;
        Sun, 15 Oct 2023 09:24:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C2D7BC433D9;
        Sun, 15 Oct 2023 16:24:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697387063;
        bh=QrbqGmCq9GHG3xrko2d71kZwRVgf9KxpetShiGnwiuQ=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=Q4UZ+s/t5y40cphZpo5oFB55wSKJLfywlss6Wc0dbJjG2FjJiitRiqcBaUGYm7zm6
         zqLRFLaAzqDbwoiewl/AxkZEarppkZOS4nOtFs+r10haOXCogNl1mfF3kIE5k5tZmq
         N13REBXgRBRNMMKCAz4e+Z/IzCO/FDeFq9sD5sZPE8FZVlIyg21hN65JEAn3gOF7/7
         c4H9ff+MOdwlycwuSy7Fte/RfRJx24qEXwz0WVfk+EVJOQzL9oMw0wt+wH3oKO2EJL
         Y9HorZ9FQP9D6e1igRVWBv+DAZQZPGPlRnNsrsJEyafuHeSG8YRO/2B+NW3EiXX+Mw
         Jut13E4SiqxiA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B264DC395EC;
        Sun, 15 Oct 2023 16:24:23 +0000 (UTC)
Subject: Re: [GIT PULL] overlayfs fixes for 6.6-rc6
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20231015120117.2131546-1-amir73il@gmail.com>
References: <20231015120117.2131546-1-amir73il@gmail.com>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20231015120117.2131546-1-amir73il@gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git ovl-fixes-6.6-rc6
X-PR-Tracked-Commit-Id: beae836e9c61ee039e367a94b14f7fea08f0ad4c
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 19fd4a91ddeec20f9971a06f6328558c392ad66a
Message-Id: <169738706372.6658.15776753018005949540.pr-tracker-bot@kernel.org>
Date:   Sun, 15 Oct 2023 16:24:23 +0000
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <brauner@kernel.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The pull request you sent on Sun, 15 Oct 2023 15:01:17 +0300:

> git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git ovl-fixes-6.6-rc6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/19fd4a91ddeec20f9971a06f6328558c392ad66a

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
