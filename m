Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBC9CC433EF
	for <linux-unionfs@archiver.kernel.org>; Wed, 30 Mar 2022 11:07:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243339AbiC3LJD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 30 Mar 2022 07:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241037AbiC3LJD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 30 Mar 2022 07:09:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DC9FDF21
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Mar 2022 04:07:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 36E98B81BBA
        for <linux-unionfs@vger.kernel.org>; Wed, 30 Mar 2022 11:07:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FD2C340EC;
        Wed, 30 Mar 2022 11:07:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648638435;
        bh=6M1SG/K1Q+upWfQItIV3JuaM741W9t1QZi0Czq4Z6JY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Gvc7Z14/eToue9nmg+aGshofEArFw6+rCGorYtO0P2W+KTFv7zeUCS3ckZkCJRB8C
         4s6tQjbj1We9AC2/3ckdFdEOYtpie8YURsnCakYkWZ8C5YV70Jj/HfKNCda0yfMEpj
         S3IGR/VkgUYofIWbkUNcqZ8RKOpD5PLIfTE2op7VeArU7Eb3/9BLAfjLN6KA4aWjIq
         +GSZ3dc6rNlLbEgaZ1zw+dRjjcy5gepQxRck1EczKzWEAFQ4VCFYHFoT78zyfhEA6X
         TyqPPLZ45N2NjboUN8mjYgAj5GEvM6qrN6d9MO1kGxuDj8mbDscOuVVqthG2repZ9X
         c1jJGacJKxXrw==
Date:   Wed, 30 Mar 2022 13:07:10 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>
Subject: Re: [PATCH v2 19/19] ovl: support idmapped layers
Message-ID: <20220330110710.sfgeue45xyy2ofqz@wittgenstein>
References: <20220330102409.1290850-1-brauner@kernel.org>
 <20220330102409.1290850-20-brauner@kernel.org>
 <CAOQ4uxj1dhNhFC6oBGj623kJ-89vU0rXPSh-wr32u4rh2_W-=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAOQ4uxj1dhNhFC6oBGj623kJ-89vU0rXPSh-wr32u4rh2_W-=g@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Mar 30, 2022 at 02:02:51PM +0300, Amir Goldstein wrote:
> On Wed, Mar 30, 2022 at 1:26 PM Christian Brauner <brauner@kernel.org> wrote:
> >
> > Now that overlay is able to take a layers idmapping into account allow
> > overlay mounts to be created on top of idmapped mounts.
> >
> > Cc: <linux-unionfs@vger.kernel.org>
> > Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> > ---
> > /* v2 */
> > unchanged
> 
> ovl_upper_idmap() changed but let's not be petty about this ;)

Fair, though I put it in the summary message. ;)
(Fwiw, the annotations aren't intended for inclusion in the tree and
will be stripped during git am :).)
