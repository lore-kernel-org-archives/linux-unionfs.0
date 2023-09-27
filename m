Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A73BE80AB9
	for <linux-unionfs@archiver.kernel.org>; Wed, 27 Sep 2023 14:39:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232207AbjI0Ojl (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 27 Sep 2023 10:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbjI0Ojk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 27 Sep 2023 10:39:40 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7514B12A
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Sep 2023 07:39:38 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id 5b1f17b1804b1-4053c6f1087so104600835e9.0
        for <linux-unionfs@vger.kernel.org>; Wed, 27 Sep 2023 07:39:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695825577; x=1696430377; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=/d0O6KoBBcVDhiAyK6/22CPBVqgPOAgVU0f7WwKl+90=;
        b=X0yInaTTVG84VNJbWXWeUZk/KiDNOJA1im6tD5SHhz9gIG8Jc9rWz5jjBs3sXQSRQT
         e/2hKDFfDBl5uXYsMgojwhJNumNJCtcXQNoGbJXbGxqmbcz061mMkiYQb8dcrf5B41mu
         Fnacv0T7/7SMErTRk7bTuLytCRQRoldRO7TovNCRi+G7wj0vNMom3Hrsn8ipejwV42Af
         n8dVmqmdJ+i51A9pRXVGJxLnl+hkF6KlTZETaD0NsFYc4Zgf/Vp3ZJv6pvDbqvz0RISc
         ylSGeNAkRaXB0qi2+qBtUI87JyKUWGyHvvu5nesp/0Q9GQkPtn3KIYz1Q21+6AmRJc9k
         5q0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695825577; x=1696430377;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/d0O6KoBBcVDhiAyK6/22CPBVqgPOAgVU0f7WwKl+90=;
        b=E87iquWpuZTiSLjRcnvcMTGa7WV9D7bOum80H416+TsoPbJntA6FqryqsiupcrMk52
         e98mSFa/gpKgXyM6AuacbS9RjuhK0sPWx2+3a7aNrRZ7l7yLzQVqOxd5XiE8xqEHzz0Z
         oK7kV2TmDpqT+izWq/LbiJ4POcW3gM61+UcN8EOEPN0Oag5zgjK4n1PrOdFtqtJWUz1t
         nHjhdtGC3sp3k0tJ7guyiJxS/GmtOFJN/7ETwRQo/isG3b2xlbrirxylisnSLICCSHsj
         33MuWlj8xVga4h15tXxq/fjth4Ea5k/U4iYW+IDXTjxGgKcRgwq6W7Klwci7ZhjdFyc5
         cOSQ==
X-Gm-Message-State: AOJu0YyLfGZXOjd7vCJvZYDLw62Nahyrw3f3EaHQJcSP6EF5bGWR9D2Y
        qvC/otoh5L93mbRKEHVtycIoLw==
X-Google-Smtp-Source: AGHT+IFvNEZDv5Y5OceM93YwR6RkX3JyiUbg2tuwwbpQakpWx4Px8t9lxkMzS5zdwGox0O4uB7W8nA==
X-Received: by 2002:a5d:66c4:0:b0:31f:84a3:d188 with SMTP id k4-20020a5d66c4000000b0031f84a3d188mr1890900wrw.22.1695825576817;
        Wed, 27 Sep 2023 07:39:36 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id r5-20020a05600c320500b003fc0505be19sm12638746wmp.37.2023.09.27.07.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Sep 2023 07:39:36 -0700 (PDT)
Date:   Wed, 27 Sep 2023 17:39:31 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Amir Goldstein <amir73il@gmail.com>, Su Hui <suhui@nfschina.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] ovl: avoid possible NULL dereference
Message-ID: <f929f35e-2599-48e4-a77f-f2002bc94482@kadam.mountain>
References: <20230925045059.92883-1-suhui@nfschina.com>
 <CAOQ4uxhv=Theeq0tEiDXEjUcKLNfaZnsVjnweX84mzWYSmFiZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxhv=Theeq0tEiDXEjUcKLNfaZnsVjnweX84mzWYSmFiZQ@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Wed, Sep 27, 2023 at 05:02:26PM +0300, Amir Goldstein wrote:
> On Mon, Sep 25, 2023 at 7:52 AM Su Hui <suhui@nfschina.com> wrote:
> >
> > smatch warn:
> > fs/overlayfs/copy_up.c:450 ovl_set_origin() warn:
> > variable dereferenced before check 'fh' (see line 449)
> >
> > If 'fh' is NULL, passing NULL instead of 'fh->buf'.
> >
> > Signed-off-by: Su Hui <suhui@nfschina.com>
> > ---
> >  fs/overlayfs/copy_up.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index d1761ec5866a..086f9176b4d4 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -446,7 +446,7 @@ int ovl_set_origin(struct ovl_fs *ofs, struct dentry *lower,
> >         /*
> >          * Do not fail when upper doesn't support xattrs.
> >          */
> > -       err = ovl_check_setxattr(ofs, upper, OVL_XATTR_ORIGIN, fh->buf,
> > +       err = ovl_check_setxattr(ofs, upper, OVL_XATTR_ORIGIN, fh ? fh->buf : NULL,
> >                                  fh ? fh->fb.len : 0, 0);
> >         kfree(fh);
> >
> > --
> > 2.30.2
> 
> After discussing this with Dan Carpenter, this is not a kernel bug,
> it is a smatch bug.

Yeah.  Sorry about that, Su Hui.  The ->buf struct member is not a
pointer, it's an array.  So this isn't really a dereference, it's just
pointer math and foo = fh->buf won't crash even if fh is NULL.

I have written a fix for this in Smatch.  I'll test it a bit before I
push it.

regards,
dan carpenter

