Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B86FBC433F5
	for <linux-unionfs@archiver.kernel.org>; Wed, 12 Jan 2022 20:28:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231941AbiALU2R (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 12 Jan 2022 15:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbiALU2Q (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 12 Jan 2022 15:28:16 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B6DBC06173F
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Jan 2022 12:28:16 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id l12-20020a7bc34c000000b003467c58cbdfso4181973wmj.2
        for <linux-unionfs@vger.kernel.org>; Wed, 12 Jan 2022 12:28:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=message-id:subject:from:reply-to:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=oAexInNwzMpQfpbOd7j5RmY7s7+LVw9dmfck3S4WdAo=;
        b=YkBfrH5Y/SLqs24AADRr4KnEjE8i6OG0da/Ajueb2VqUn9NoKxSTU2bQXRgq3QyZNn
         HFbNgdKGotG+bekS1JkV9OnHIjG6n4R87PB4saNewbJbrwc72PtY7osSw+7yr/bmiPVG
         b6GdTJf6VKj0vdsEHuLipp5OqNbWesJ0f4afk0ritJpK5EsmiXEVigDA9CaS5J4tJ2dx
         YX339t9jYA/XVZV4Om4bWhDGx3f21z9N6gLLazWgUO1R4h+e486pnwyGG1L6HjzEzdI2
         ONqOAtgaqA1PUrgLO9tmLul+BZrSakydzQSZ+gUIB+TvurElHkf20bs2tTG+d7n4Mmpy
         by/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:reply-to:to:cc:date
         :in-reply-to:references:user-agent:mime-version
         :content-transfer-encoding;
        bh=oAexInNwzMpQfpbOd7j5RmY7s7+LVw9dmfck3S4WdAo=;
        b=SQ/sTtdCJS/GWInmzZkteE4ObrNiofOS4ICrjI5aswH/1QTRsIudXxgIoYxxvXEVWO
         xfsp5IeP4zUxs9Dd46HhWreln7OMRWwDZuAxtj3M1GS0jp04+S2XAfHPOxW2Rz4jUPQM
         qMxGRjt8WAHhfb2BpAXXaaedM9qeoK7iJruCrQj+3dTEO61fE70mYwrhTembh767j2Ku
         YUjwU3E7zMrg3T1XmWvhpxG0azcTUGV7nQM6O/qSDFBj8fKdrSExjJ568rVfqMX25xpr
         606rjxF46JGdZ0YWf8fezSUB7Z/UxX7msbaqtBcOroPm3/DBWcbybHwVQPIIxatuwNLw
         +yDA==
X-Gm-Message-State: AOAM531QXTLvas3JdGEV++53VPoz0ryWVndPK8JYQFtKZ6gB9nH3EN1t
        A5INUDZoXlVHj9GI7A1L4d8=
X-Google-Smtp-Source: ABdhPJxQPMX/99Gpjjd7Xy7YloAS3ejCmcAfjadhJE80yV9PyMmHxLgv4wGqSBdzGIfPjkAcYWhwiA==
X-Received: by 2002:a05:600c:4ed1:: with SMTP id g17mr8237408wmq.112.1642019294867;
        Wed, 12 Jan 2022 12:28:14 -0800 (PST)
Received: from mars.fritz.box ([2a02:8070:bb0:8700:3e7c:3fff:fe20:2cae])
        by smtp.gmail.com with ESMTPSA id l4sm863801wry.85.2022.01.12.12.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jan 2022 12:28:14 -0800 (PST)
Message-ID: <515a5cf0d1e35bee96e1ec9a49a46dfb545871eb.camel@googlemail.com>
Subject: Re: [PATCH] ovl: fix NULL pointer dereference
From:   Christoph Fritz <chf.fritz@googlemail.com>
Reply-To: chf.fritz@googlemail.com
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Kevin Locke <kevin@kevinlocke.name>, linux-unionfs@vger.kernel.org
Date:   Wed, 12 Jan 2022 21:28:13 +0100
In-Reply-To: <c3ede9cee662964c174fdccc0039df8fa0a2be9b.camel@googlemail.com>
References: <10d8ed194b934c298713ad7f0958329b46573dd1.camel@googlemail.com>
         <c3ede9cee662964c174fdccc0039df8fa0a2be9b.camel@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

> 
> [    9.956738] overlayfs: failed to retrieve upper fileattr
> (index/#61, err=-25)
> [   10.311610] overlayfs: failed to retrieve upper fileattr
> (index/#d, err=-25)
> [   10.712019] overlayfs: failed to retrieve upper fileattr
> (index/#e, err=-25)
> [   31.901577] overlayfs: failed to retrieve upper fileattr
> (index/#64, err=-25)
> 
> These have been -ENOIOCTLCMD errors but got (falsely?) converted to
> -ENOTTY by the recently introduced commit 5b0a414d06c3 ("ovl: fix
> filattr copy-up failure"):
> 
> +       if (err == -ENOIOCTLCMD)
> +               err = -ENOTTY;
> 
> Any ideas?
> 

Doing the same "quirk" for upper fileattr seems to fix the issues, but
I have no clue about any other implications:

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 347b06479663..1e69bc000dd8 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -167,6 +167,8 @@ static int ovl_copy_fileattr(struct inode *inode, struct path *old,
 
 	err = ovl_real_fileattr_get(new, &newfa);
 	if (err) {
+		if (err == -ENOTTY || err == -EINVAL)
+			return 0;
 		pr_warn("failed to retrieve upper fileattr (%pd2, err=%i)\n",
 			new->dentry, err);
 		return err;





