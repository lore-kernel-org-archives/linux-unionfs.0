Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BD6AC2FC2E
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Aug 2023 14:33:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351943AbjHQOco (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Aug 2023 10:32:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351997AbjHQOca (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Aug 2023 10:32:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BD4F30D6
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 07:32:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0100D66185
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 14:32:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A25AC433C8;
        Thu, 17 Aug 2023 14:32:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692282747;
        bh=g+IMzTU04aKrTeh3UByWzsJWyT2xB8Ii9VB482iO7xA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DUZL064g8fMvdrIcfd8PP64DjHM+qoKOLshEChtfcAfbL6nOtaOzAYeEPAqi7b3a/
         0LH1vzr5VNWoZx2LIjYH4e91F61F4j5FAD54hyTnhhpeTaTdVNetwlS+ols/052o2d
         +zE4X/m96DHMOYB5aY5Vt3SwbTT7zZUfJd9b4qYjDGBNJi/q0FG31Yw0GdCBleKEcB
         gCr7fI6OwU59tsixiRIeZXbQFakyseM3k3rCr/agizqRSXnktq797xRf9kDRAH/+4n
         kH673Yv26tLcgHreDnPp6DbnBKD3x8Yx1TUPk52rayT2sRBbrF2mcFaqgtGBejyaHw
         jMROuSs4xvMew==
Date:   Thu, 17 Aug 2023 16:32:24 +0200
From:   Christian Brauner <brauner@kernel.org>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH v3 0/4] fs: export __mnt_{want,drop}_write to modules
Message-ID: <20230817-anfechtbar-ruhelosigkeit-8c6cca8443fc@brauner>
References: <20230816152334.924960-1-amir73il@gmail.com>
 <20230817054446.961644-1-amir73il@gmail.com>
 <20230817-vagabunden-glatze-c30318a0ecc0@brauner>
 <CAOQ4uxhsyGwoOiTAegPmFBQiJmuhs_RZNzrb7L3gXLRxNmR3HA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxhsyGwoOiTAegPmFBQiJmuhs_RZNzrb7L3gXLRxNmR3HA@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Aug 17, 2023 at 04:55:55PM +0300, Amir Goldstein wrote:
> On Thu, Aug 17, 2023 at 4:38 PM Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Thu, Aug 17, 2023 at 08:44:46AM +0300, Amir Goldstein wrote:
> > > overlayfs is going to use those to grab a write reference on the
> > > upper fs during copy up.
> > >
> > > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > > ---
> > >
> > > Christian,
> > >
> > > This patch is needed for the ovl_want_write() changes [1],
> > > which I forgot to CC you on.
> > >
> > > Please ACK if you approve.
> > >
> > > Thanks,
> > > Amir.
> > >
> > > [1] https://lore.kernel.org/linux-unionfs/20230816152334.924960-1-amir73il@gmail.com/
> > >
> > >  fs/namespace.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/fs/namespace.c b/fs/namespace.c
> > > index e157efc54023..370328b204f1 100644
> > > --- a/fs/namespace.c
> > > +++ b/fs/namespace.c
> > > @@ -386,6 +386,7 @@ int __mnt_want_write(struct vfsmount *m)
> > >
> > >       return ret;
> > >  }
> > > +EXPORT_SYMBOL_GPL(__mnt_want_write);
> >
> > Puh, not excited about that but also no real reason to say no other than
> > generic worries about it being abused.
> > But maybe let's not export underscore variants. Might make sense to at
> > least name them differently? mnt_want_write_locked()?
> 
> Heh, it's not locked. It happens to be called with sb_start_write() from
> mnt_want_write(), but from do_dentry_open() it's actually called *before*
> file_start_write(), because the mnt_writers refcount and sb_writers lock
> are not strictly ordered, which is very convenient for ovl copy up.
> 
> We could go for mnt_{get,put}_write(), but that's a bit close to
> mnt_get_writers().
> 
> We could go for mnt_{get,put}_write_access(), like helpers with similar
> names for inode.

Fine by me. I'm just not happy with this __*() thing.

> 
> I don't really mind, as long as this doesn't become a bike shedding thing...

So I brought all that paint for nothing?
