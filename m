Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0735BC072A2
	for <linux-unionfs@archiver.kernel.org>; Fri, 17 Nov 2023 14:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbjKQO3E (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 17 Nov 2023 09:29:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbjKQO3E (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Nov 2023 09:29:04 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14023B8;
        Fri, 17 Nov 2023 06:29:01 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9B306C433C7;
        Fri, 17 Nov 2023 14:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1700231340;
        bh=xQuC6Jvfo0Of8B33Yv/38dKbdxjnoPlyeFBrD4qVPk0=;
        h=Subject:From:In-Reply-To:References:Date:To:Cc:From;
        b=PS4jM8GbjiiSizZTakgFDYGle9YKvHK6zWJi7oZ4N2f5wGkAIkjGfrWlFlJl5ugkq
         WSljMmXclwhsTJAQAnkJxO2EJY+1rSqquqBADbBvy/9Q7J5GAchIn8pEXCcdt9+M+6
         EkrgKYI1+cMYo36i0gcNOORxZTxxcxvpKeDpOkpU9S2OdxrF9LdqSRi8zOBnwSZOgo
         1w41fwH6fzJm0fB8ret0GBaoGF7YUILJiJ3x3dYciArcXEcVDG+o9ppA304uuUiKI0
         vFAn5akcKmXXvblH3W+U4UQDek0JN0AoGi1iIvQNdmPFYFsOujopdRks8GdaIoemdI
         JuOaTgbJSh6rg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 898E9C4316B;
        Fri, 17 Nov 2023 14:29:00 +0000 (UTC)
Subject: Re: [GIT PULL] overlayfs fixes for 6.7-rc2
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20231117131315.1927413-1-amir73il@gmail.com>
References: <20231117131315.1927413-1-amir73il@gmail.com>
X-PR-Tracked-List-Id: <linux-unionfs.vger.kernel.org>
X-PR-Tracked-Message-Id: <20231117131315.1927413-1-amir73il@gmail.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git ovl-fixes-6.7-rc2
X-PR-Tracked-Commit-Id: 37f32f52643869131ec01bb69bdf9f404f6109fb
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 6bc40e44f1ddef16a787f3501b97f1fff909177c
Message-Id: <170023134055.28622.6849058513211945485.pr-tracker-bot@kernel.org>
Date:   Fri, 17 Nov 2023 14:29:00 +0000
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        Christian Brauner <brauner@kernel.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The pull request you sent on Fri, 17 Nov 2023 15:13:15 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/overlayfs/vfs.git ovl-fixes-6.7-rc2

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/6bc40e44f1ddef16a787f3501b97f1fff909177c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/prtracker.html
