Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 424C2C433F5
	for <linux-unionfs@archiver.kernel.org>; Thu,  6 Oct 2022 12:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231444AbiJFMkA (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 6 Oct 2022 08:40:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiJFMj7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Oct 2022 08:39:59 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 324BD14D2F
        for <linux-unionfs@vger.kernel.org>; Thu,  6 Oct 2022 05:39:58 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a26so4294891ejc.4
        for <linux-unionfs@vger.kernel.org>; Thu, 06 Oct 2022 05:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=fZL8Jd2EOlh929R0aLNRa+SR7xNfJ1In5+5PnBcaKuk=;
        b=pAur5nUnSAn+UskkNnCoVxnVuS8RLJWChAr86S+fx/72U+z2VE5kwhYv/2bPVs0eMx
         wVxzMtXiqlE5aavhd7YXBk9NT31HH6Q3OC3hqOV+eOLhjR+jkmTTKIWWMqeXRYQm82j5
         Fowb+bkCBdUx2m5a+gOjFNdKXXCMKKvTrNWeA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=fZL8Jd2EOlh929R0aLNRa+SR7xNfJ1In5+5PnBcaKuk=;
        b=y6p0Hi+OYvOH8kUBzQ7Sxvz2GaCk3vc3pCSOxFWkGumLyqxhAwfNFZ9lOn/ENM4VrH
         KxaILw91t9Zza1QjO5EoQ9qBWaFTbHuxWB6Yl1EBVVV6vWXAV/mcMlOfTGEa6cbV8I53
         mf7/un2tNcLzBqbDGXubK7N9JciKbBxLflN7dy+7EqcYUnMnIaIYfaFAfkmC/xzW+iaV
         /AIRKJqA9+KauRp5XtaAUXdCTbBRGcupzlL7nGYwED2JmZQZ7aom9fFf+b/8A32dOZbY
         39iwzIDWNLx5r70lnM8SDox9Ysh1V+eKwKPEvkeBZZRzDBCy2jLOXV+pvunGMj4pJmNb
         fq1Q==
X-Gm-Message-State: ACrzQf3+aEJVOw6xNVdyUcpEoqfh+kCIFcFMaKEUQ0qhOJ8qzkpaz+p/
        ha6xqfCZE+f/k/aUjsKTEwI8CK/SycTZgFTrXlJ/Uw==
X-Google-Smtp-Source: AMsMyM4MPJ/9sVWjFo9JJ3AwknM+GA0A5q3/VVAxNZmy61IheRpWQauzTA/K4xG5wILBUEA5J3xoBLK+Udfui3gOFI0=
X-Received: by 2002:a17:907:62a1:b0:781:b320:90c0 with SMTP id
 nd33-20020a17090762a100b00781b32090c0mr3641203ejc.255.1665059996796; Thu, 06
 Oct 2022 05:39:56 -0700 (PDT)
MIME-Version: 1.0
References: <20220929153041.500115-1-brauner@kernel.org> <20220929153041.500115-23-brauner@kernel.org>
In-Reply-To: <20220929153041.500115-23-brauner@kernel.org>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Thu, 6 Oct 2022 14:39:45 +0200
Message-ID: <CAJfpegu_kihAL7VV4=7aFfWVxEx+wxGhBkQ6A8q2-fFbHCit5w@mail.gmail.com>
Subject: Re: [PATCH v4 22/30] ovl: implement set acl method
To:     Christian Brauner <brauner@kernel.org>
Cc:     linux-fsdevel@vger.kernel.org, Seth Forshee <sforshee@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-unionfs@vger.kernel.org,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, 29 Sept 2022 at 17:31, Christian Brauner <brauner@kernel.org> wrote:
>
> The current way of setting and getting posix acls through the generic
> xattr interface is error prone and type unsafe. The vfs needs to
> interpret and fixup posix acls before storing or reporting it to
> userspace. Various hacks exist to make this work. The code is hard to
> understand and difficult to maintain in it's current form. Instead of
> making this work by hacking posix acls through xattr handlers we are
> building a dedicated posix acl api around the get and set inode
> operations. This removes a lot of hackiness and makes the codepaths
> easier to maintain. A lot of background can be found in [1].
>
> In order to build a type safe posix api around get and set acl we need
> all filesystem to implement get and set acl.
>
> Now that we have added get and set acl inode operations that allow easy
> access to the dentry we give overlayfs it's own get and set acl inode
> operations.
>
> The set acl inode operation is duplicates most of the ovl posix acl
> xattr handler. The main difference being that the set acl inode
> operation relies on the new posix acl api. Once the vfs has been
> switched over the custom posix acl xattr handler will be removed
> completely.
>
> Note, until the vfs has been switched to the new posix acl api this
> patch is a non-functional change.
>
> Link: https://lore.kernel.org/all/20220801145520.1532837-1-brauner@kernel.org [1]
> Signed-off-by: Christian Brauner (Microsoft) <brauner@kernel.org>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>

Thanks,
Miklos
