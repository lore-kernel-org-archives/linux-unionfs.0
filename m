Return-Path: <SRS0=9nie=3Y=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1882CC2D0B1
	for <linux-unionfs@archiver.kernel.org>; Tue,  4 Feb 2020 13:25:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E527D2166E
	for <linux-unionfs@archiver.kernel.org>; Tue,  4 Feb 2020 13:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1580822709;
	bh=Rc6NqeXWz9S3r4LWSxPFOJ2ycNr1OekbG9nhhgvWA9c=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=n7OWsdEnVenN1Azg6317wuS6+QYw4twR0kP30rat3lv3lFTbDDQbBL3dlLj10bGMM
	 z37xPkGx+AMStrFxQB1H7dusEYyztmNHY0nCzvPN1dy1gzGynR+X/kFJuhJy1K0H2/
	 uR16dcJMCDrNrruqr3pjgv4TNXXboTz/XV6APenM=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgBDNZE (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 4 Feb 2020 08:25:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:35310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727439AbgBDNZE (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 4 Feb 2020 08:25:04 -0500
Subject: Re: [GIT PULL] overlayfs update for 5.6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580822703;
        bh=Rc6NqeXWz9S3r4LWSxPFOJ2ycNr1OekbG9nhhgvWA9c=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=vG5IZN1vJ5ZIqJPAhvKYdjh8/GlnSTQojD1RzAybg0MIron8Xopc8DQ/DhqjyxrnB
         dVPlKVQa1NZ16nasaw+jf+MuNhfUDDlykeH9GON6+Pwa1Cro3iF5nRvexUsyEibbu3
         PFABCSVK/Bu08Edz0Yoc4CIrcpU2Vn0aSpjVdMKU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200204093758.GA7822@miu.piliscsaba.redhat.com>
References: <20200204093758.GA7822@miu.piliscsaba.redhat.com>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200204093758.GA7822@miu.piliscsaba.redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git
 tags/ovl-update-5.6
X-PR-Tracked-Commit-Id: a4ac9d45c0cd14a2adc872186431c79804b77dbf
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 7f879e1a94ac99586abf0659c03f35c1e48279c4
Message-Id: <158082270392.19118.7086093890010037735.pr-tracker-bot@kernel.org>
Date:   Tue, 04 Feb 2020 13:25:03 +0000
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The pull request you sent on Tue, 4 Feb 2020 10:37:58 +0100:

> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-update-5.6

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/7f879e1a94ac99586abf0659c03f35c1e48279c4

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
