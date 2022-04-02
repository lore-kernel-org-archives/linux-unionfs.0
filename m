Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E143C433EF
	for <linux-unionfs@archiver.kernel.org>; Sat,  2 Apr 2022 06:19:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232603AbiDBGVo (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sat, 2 Apr 2022 02:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbiDBGVm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 2 Apr 2022 02:21:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7241176640
        for <linux-unionfs@vger.kernel.org>; Fri,  1 Apr 2022 23:19:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0DB160F6F
        for <linux-unionfs@vger.kernel.org>; Sat,  2 Apr 2022 06:19:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CEC1C340EE;
        Sat,  2 Apr 2022 06:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648880388;
        bh=lk4shpnqfIN+s8xvlbuYjzVxQ+t3EgcQCiCYKOvSUxo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jNJbZ9QXg5cgvQRCjlIORyqtMb69EwxtEXtw17eAoGRAapZmcl2q+sF0lUuM8E44U
         UzZewTmkqrhw3LgeRXtRtO6StRngTM64Dog6Wdtp9Ks+5D+W82TIoyikzGiQcL9iKA
         ENrYvcbKH/mISDiE4GkFU4NkZ0UxfeqD+UUJbCACsAyDyT6wGTXHiLyFoUdNbikDTL
         o85pgeoihQCv2e5aMFdK9zxirGr8wAGm+vghiBGOpQddnC9VIaeGnYbuSBbmlUECC+
         uBg1j4RsbmsOwPLKwhDB2E6Bsixk+hOIScVd6+4pCeQ6Ybi2G8z8RathJmlsJQZJyr
         Z5AHPvxW4y12w==
Date:   Sat, 2 Apr 2022 08:19:41 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Vivek Goyal <vgoyal@redhat.com>
Cc:     Amir Goldstein <amir73il@gmail.com>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org,
        Aleksa Sarai <cyphar@cyphar.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        Rodrigo Campos Catelin <rodrigo@sdfg.com.ar>,
        Seth Forshee <sforshee@digitalocean.com>,
        Luca Bocassi <luca.boccassi@microsoft.com>,
        Lennart Poettering <mzxreary@0pointer.de>,
        =?utf-8?B?U3TDqXBoYW5l?= Graber <stgraber@ubuntu.com>
Subject: Re: [PATCH v3 19/19] ovl: support idmapped layers
Message-ID: <20220402061941.odtwzcfoz6nk3uni@wittgenstein>
References: <20220331112318.1377494-1-brauner@kernel.org>
 <20220331112318.1377494-20-brauner@kernel.org>
 <YkddyaCtRdTRPtpL@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YkddyaCtRdTRPtpL@redhat.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Apr 01, 2022 at 04:17:13PM -0400, Vivek Goyal wrote:
> On Thu, Mar 31, 2022 at 01:23:17PM +0200, Christian Brauner wrote:
> > Now that overlay is able to take a layers idmapping into account allow
> > overlay mounts to be created on top of idmapped mounts.
> > 
> > Cc: <linux-unionfs@vger.kernel.org>
> > Tested-by: Giuseppe Scrivano <gscrivan@redhat.com>
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>
> > ---
> > /* v2 */
> > - Turn on support for idmapped mounts in ovl_upper_idmap() helper here
> >   after we've introduced it earlier in the series and made it return the
> >   initial idmapping.
> > 
> > /* v3 */
> > unchanged
> > ---
> >  fs/overlayfs/ovl_entry.h | 2 +-
> >  fs/overlayfs/super.c     | 4 ----
> >  2 files changed, 1 insertion(+), 5 deletions(-)
> > 
> > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> > index 79b612cfbe52..898b002a5c6f 100644
> > --- a/fs/overlayfs/ovl_entry.h
> > +++ b/fs/overlayfs/ovl_entry.h
> > @@ -92,7 +92,7 @@ static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
> >  
> >  static inline struct user_namespace *ovl_upper_idmap(struct ovl_fs *ofs)
> 
> Same minor nit here. Will ovl_upper_mnt_userns() be better for
> readability. If it is too long, may be ovl_upper_mnt_uns().
> 
> I have this general comment here and other places
> where "idmap" has been used. "idmap" is just one property vfs
> derives from user namespace associated with mnt.

I don't have strong feelings here so I don't mind changing the naming.
But I honestly don't know if that's wort it since the it isn't passed as
an argument. But sure.
