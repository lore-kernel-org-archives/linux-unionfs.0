Return-Path: <SRS0=h7tn=4M=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D95C35673
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Feb 2020 02:45:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B3B9B20658
	for <linux-unionfs@archiver.kernel.org>; Mon, 24 Feb 2020 02:45:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=themaw.net header.i=@themaw.net header.b="FNwTAdHt";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="MTEQ0/si"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727180AbgBXCp4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 23 Feb 2020 21:45:56 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:34177 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727168AbgBXCp4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 23 Feb 2020 21:45:56 -0500
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 15C784B8;
        Sun, 23 Feb 2020 21:45:55 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sun, 23 Feb 2020 21:45:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=
        message-id:subject:from:to:cc:date:in-reply-to:references
        :content-type:mime-version:content-transfer-encoding; s=fm2; bh=
        s5Zfoadpx+pNCBSJRW69C71D/q3G2eT1Z4AraQAtWIw=; b=FNwTAdHtEQf4lV6n
        fxF98PL7t1lBbbDmSXSIATpo+aC1Tj/H4W8JKmhNpwAJtYdrt9JvaDLaZA96Ghmt
        52HHMC4DTGl0FjI6zpEvbNSKd1mlpVOqNUvjkOl7i/yD1G5mnRdI7fN2lVBN0nzt
        IN5/HHJH/Ktx6xvGI+cJ3M1IFVTOMQMxK5jTfxu8LHQPg4CTgpp9K/RVAvhWrMjV
        7EbZaBYzSUDSIfzKUR/dwEz4loj7i5Zjfx0U0u6B2HpJPktgcxooZF7olQQneZgl
        JXMraNRDFCncurqMaPn58o9Wrr61udHd+Eq5yzAwWF+c5JLAiT7K+Fn8Ff8GJVgB
        c9rpfA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=s5Zfoadpx+pNCBSJRW69C71D/q3G2eT1Z4AraQAtW
        Iw=; b=MTEQ0/siZ9FKsjN5bauguWL3cmn+fICsfaL7V4Kairj4IMLvMkJQmJ6Wt
        oIGPgAsXMjmlIpEsJ7lBYmcd97WciBAqFfD1KkQClbAOWyGf9GlVYuLa0uudnUte
        upkgX9/2l6q6sxMvDcoGAouyhcV8ilXu3Vi0VugcOGgU/9AfwkhEh+Gtyur6/QWa
        nQOK/ZHNtaEVtZiW78J8VG4Qvo7VQGChLYqvS+2dm/4asuOEAmoPAC+BxnSmQPSh
        FgghBbPrYCcK1EE3A/P0kbJmupbrV/Bi97Z8foJGkQzwoYnKZmbNpBux6ET0s9KN
        1/n4Io1xbvmMk39LbDMhxYRqoi5bg==
X-ME-Sender: <xms:4ThTXs9vzzta2WJFV_QhQatatbrv6-lPMBHTxhazrDZivsBL17YTpA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrkeelgdehtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpefkuffhvfffjghftggfggfgsehtjeertddtreejnecuhfhrohhmpefkrghnucfm
    vghnthcuoehrrghvvghnsehthhgvmhgrfidrnhgvtheqnecuffhomhgrihhnpehkvghrnh
    gvlhdrohhrghenucfkphepuddukedrvddtledrudektddrvddvleenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehrrghvvghnsehthhgvmhgrfi
    drnhgvth
X-ME-Proxy: <xmx:4ThTXo-Kvws7hJYhR04bViPCu-zS-2st7Ql0Q970kpmEKiupwOWuiQ>
    <xmx:4ThTXtBliZa2C7jGSIJ8DT_Jqsi6zi9TV9KzlxGu-RzPK_FPjdusjQ>
    <xmx:4ThTXgxDuNQSU6SNa-BMYFmG75bPNIFF_pWDAQckYny1Eqbbwblu6w>
    <xmx:4jhTXosSnl9yH1EJszSlI5AUQrvzVxtqQ6EQhQuxndK8Jzj8zqsqTg>
Received: from mickey.themaw.net (unknown [118.209.180.229])
        by mail.messagingengine.com (Postfix) with ESMTPA id 52B0C3060BD1;
        Sun, 23 Feb 2020 21:45:51 -0500 (EST)
Message-ID: <0f24065ec6aaf654602f03e241747efa4fbe73fd.camel@themaw.net>
Subject: Re: [RFC PATCH 0/5] allow unprivileged overlay mounts
From:   Ian Kent <raven@themaw.net>
To:     "Serge E. Hallyn" <serge@hallyn.com>,
        Miklos Szeredi <miklos@szeredi.hu>
Cc:     "Eric W . Biederman" <ebiederm@xmission.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 24 Feb 2020 10:45:47 +0800
In-Reply-To: <20191029170137.GA21633@mail.hallyn.com>
References: <20191025112917.22518-1-mszeredi@redhat.com>
         <CAJfpegv1SA7b45_2g-GFYrc7ZsOmcQ2qv602n=85L4RknkOvKQ@mail.gmail.com>
         <20191029170137.GA21633@mail.hallyn.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, 2019-10-29 at 12:01 -0500, Serge E. Hallyn wrote:
> On Fri, Oct 25, 2019 at 01:35:20PM +0200, Miklos Szeredi wrote:
> > On Fri, Oct 25, 2019 at 1:30 PM Miklos Szeredi <mszeredi@redhat.com
> > > wrote:
> > > Hi Eric,
> > > 
> > > Can you please have a look at this patchset?
> > > 
> > > The most interesting one is the last oneliner adding
> > > FS_USERNS_MOUNT;
> > > whether I'm correct in stating that this isn't going to introduce
> > > any
> > > holes, or not...
> > 
> > Forgot the git tree:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git#ovl-
> > unpriv
> > 
> > Thanks,
> > Miklos
> 
> I've looked through it, seemed sensible to me.

Seems sensible to me too but I'm not sure what I'm looking for.

Perhaps a bit more on how this is secure to give an idea what's been
checked and where to focus so the the survey can be broadened from
there... I'm not sure.

For example, from my simple minded view I wonder about the posix acl
code.

In ovl_posix_acl_xattr_set() there is a call to posix_acl_from_xattr()
that uses init_user_ns. I wonder if that should be the current user ns
in this case but I'm not sure?

Ian

