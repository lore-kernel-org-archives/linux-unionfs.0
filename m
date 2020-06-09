Return-Path: <SRS0=I5aa=7W=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3FC8C433DF
	for <linux-unionfs@archiver.kernel.org>; Tue,  9 Jun 2020 23:10:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BE6B82076A
	for <linux-unionfs@archiver.kernel.org>; Tue,  9 Jun 2020 23:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1591744220;
	bh=6Xo62iJr2zpidKbXDs2s4f8sNSkKIUUvO8xWd4fzxqY=;
	h=Subject:From:In-Reply-To:References:Date:To:Cc:List-ID:From;
	b=wj2uE8bjPkuwxfvIW6N5KZBWNkSVsAMYrhX/L/cKvU2VBTpgeud5jAZ3UrcgeF0Xa
	 mTEsjJzccx1G1Xp6Y0LNK0bfngCCs/fsbSg7oTLmjqpUJ4r5GScHtdVb1Wz0pMmb2/
	 PCNH04d7qFqrwz4RT+S7LJ6Bu3gIu83rU+mrfBkE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725468AbgFIXKQ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 9 Jun 2020 19:10:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:42230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726404AbgFIXKF (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 9 Jun 2020 19:10:05 -0400
Subject: Re: [GIT PULL] overlayfs update for 5.8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591744205;
        bh=6Xo62iJr2zpidKbXDs2s4f8sNSkKIUUvO8xWd4fzxqY=;
        h=From:In-Reply-To:References:Date:To:Cc:From;
        b=Vb+DEEsIC0vMD2aKhDy3LqbhW5oLPArtinImcMGumUgQH0IMM3W/T/ufFe/D45gp0
         eU7sNPtdVJUuhFIYJmms36f5OR+S2fYPwouSJD4tU8pp3mi2NHCXAnP9w0Wb3c0W/r
         zo/orNLHrUllhaBqJpo4UPzmSMmBD+e5iASg/ThU=
From:   pr-tracker-bot@kernel.org
In-Reply-To: <20200609203718.GB6171@miu.piliscsaba.redhat.com>
References: <20200609203718.GB6171@miu.piliscsaba.redhat.com>
X-PR-Tracked-List-Id: <linux-fsdevel.vger.kernel.org>
X-PR-Tracked-Message-Id: <20200609203718.GB6171@miu.piliscsaba.redhat.com>
X-PR-Tracked-Remote: git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git
 tags/ovl-update-5.8
X-PR-Tracked-Commit-Id: 2068cf7dfbc69c4097c95af3a0bd943ced155a76
X-PR-Merge-Tree: torvalds/linux.git
X-PR-Merge-Refname: refs/heads/master
X-PR-Merge-Commit-Id: 52435c86bf0f5c892804912481af7f1a5b95ff2d
Message-Id: <159174420503.2962.6834568468751753688.pr-tracker-bot@kernel.org>
Date:   Tue, 09 Jun 2020 23:10:05 +0000
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-unionfs@vger.kernel.org
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

The pull request you sent on Tue, 9 Jun 2020 22:37:18 +0200:

> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-update-5.8

has been merged into torvalds/linux.git:
https://git.kernel.org/torvalds/c/52435c86bf0f5c892804912481af7f1a5b95ff2d

Thank you!

-- 
Deet-doot-dot, I am a bot.
https://korg.wiki.kernel.org/userdoc/prtracker
