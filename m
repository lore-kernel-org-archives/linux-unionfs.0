Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D64C433EF
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Apr 2022 11:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345709AbiD1Lx4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Apr 2022 07:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235340AbiD1Lxj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Apr 2022 07:53:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7512F69CE7
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Apr 2022 04:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5D37B82BA0
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Apr 2022 11:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC71C385A9;
        Thu, 28 Apr 2022 11:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651146617;
        bh=twuxQHDveP2dBjnlyHTWOCjJJDMSosB0kIE0sbF0aoE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TyKXQOGKka8pTkPOJMbyToUQ25AxgdK/V8Mx38QFx+FE7G0k3R2FT/OZclZ9yEQf3
         ZVj6rrvcSRqruDBn4mulcNkjmfKx8df0QrQkUjmTgki73qH21TDfzXqR2nb4MrkxFp
         KE5+ykLuEyBK1gaaQKYgc3iU5nhpAUfYzn/w4OVafB1HJxmcFJ9uGEAInDfb7flA7K
         9qD+Nyv1Q1pD28QyeyQf+HWNy8+YuVJS4Y7vLYQDtjRLqP9tp8S05znjQY7Rbe9ZHQ
         pPMMSno3up9IHptlOSE5cIwNLmf2k1DRSSgUSFKAwdtPuMYgIfKSBW8XvRmbq468j8
         guIZctOOpwTdw==
Date:   Thu, 28 Apr 2022 13:50:11 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>
Subject: Re: [PATCH v5 13/19] ovl: handle idmappings for layer lookup
Message-ID: <20220428115011.4avy5edqla3zs3gs@wittgenstein>
References: <20220407112157.1775081-1-brauner@kernel.org>
 <20220407112157.1775081-14-brauner@kernel.org>
 <CAJfpegtXfrgb3qQTvqu6mtunhFjC-FwXcRvqMY4h-ZcjWyhUFg@mail.gmail.com>
 <20220428103046.kizonrkl7h2f2uvc@wittgenstein>
 <CAJfpeguor9gbfTgaHeZ-RxXoGM6V953vrrksWp9E8cOzc+gLDw@mail.gmail.com>
 <CAJfpegtJNVtsBFSH=KDa1CRuWiu1Nywc1AsAJKBJsXFBqrL-Jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAJfpegtJNVtsBFSH=KDa1CRuWiu1Nywc1AsAJKBJsXFBqrL-Jw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 28, 2022 at 01:35:32PM +0200, Miklos Szeredi wrote:
> On Thu, 28 Apr 2022 at 13:30, Miklos Szeredi <miklos@szeredi.hu> wrote:
> 
> > So I guess the proper fix would be to introduce a version of
> > lookup_one_len() without inode_permission()...
> 
> OTOH, we do have CAP_DAC_READ_SEARCH already in the syscall path and
> knfsd won't be using mnt_userns, so just passing init_user_ns should
> be fine as a quick fix.
> 
> I'm in the process of applying these patches, so if there's no
> objection, I'll make this change.

Sounds good! Thank your for fixing this up in-tree. Appreciate it!
