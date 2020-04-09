Return-Path: <SRS0=VDYA=5Z=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F092C2BA1B
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Apr 2020 04:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 55A4020936
	for <linux-unionfs@archiver.kernel.org>; Thu,  9 Apr 2020 04:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1586408108;
	bh=jUpJ31BbW2mHk4Zs/dET7SWdHJgma+q5ROKfc9fq3Zw=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=AArD0Ux/tN9bKTcYYIhiAdy+F5dUpd8ld7DPcwXvS/Cxuk6Ix8HWVlwDuVVQ4iN6I
	 DtZ9YISG7rkVQ2tV0Fucq6hUEZaTXvli7CnaxUkLRGF4whTmS3lF0bFTWJI4HCQ5Jz
	 v0laHqIG/s4FyJ5TueDVLFYsnSndQ3hRsEpJcFjA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726552AbgDIEzD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 9 Apr 2020 00:55:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:43990 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725783AbgDIEzD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Apr 2020 00:55:03 -0400
Subject: Re: [GIT PULL] overlayfs update for 5.7
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586408103;
        bh=jUpJ31BbW2mHk4Zs/dET7SWdHJgma+q5ROKfc9fq3Zw=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=dYXFozcfYj24k/zjfdYtdPyUD8ucg+h1vLhMksN9uH3w3lMgfmpDVP/mxMc8zNFzw
         kNrPXGYpPvPaFaUlQcK5sJPY6+HzZt1QSAyXfBGj/0YgJPBfO/05yBrijdPoM1S1hf
         FX6p2mNzunCTwJj/utCe6RuKiGeoOZANOLazz31A=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200408085423.GA21974@miu.piliscsaba.redhat.com>
References: <20200408085423.GA21974@miu.piliscsaba.redhat.com>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200408085423.GA21974@miu.piliscsaba.redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git
 tags/ovl-update-5.7
X-PR-Tracked-Commit-Id: 2eda9eaa6d7ec129150df4c7b7be65f27ac47346
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: c6b80eb89b55590b12db11103913088735205b5c
Message-Id: <158640810364.3202.13189376481193073892.pr-tracker-bot@kernel.org>
Date:   Thu, 09 Apr 2020 04:55:03 +0000
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The pull request you sent on Wed, 8 Apr 2020 10:54:23 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-update-5.7

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/c6b80eb89b55590b12db11103913088735205b5c

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
