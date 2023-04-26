Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F362C7618E
	for <linux-unionfs@archiver.kernel.org>; Wed, 26 Apr 2023 12:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240503AbjDZMjG (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 26 Apr 2023 08:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240010AbjDZMjF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2023 08:39:05 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C6C26B8
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2023 05:39:04 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id 4fb4d7f45d1cf-506bdf29712so52996371a12.0
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2023 05:39:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1682512743; x=1685104743;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WiJVTK8jkH0oseeeZCUccv7KlmTTWCLEzwFbGQSh0LE=;
        b=A4mU3JAJi8QZvf8Bu9A0qCKV4HbbP4U2oJFNsEMBvtJC13odW5w8Fcloxh50tWJs5B
         VK4JgQuHfeI11bKhgD08SPTfLCQZhl2maDNIHu24jgJGb63Lzy0gSBOfxfHvWZa0UlKQ
         9yQITX8ZMeBwvjV1KzCsMYiTnMYJPROeOqHmY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682512743; x=1685104743;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WiJVTK8jkH0oseeeZCUccv7KlmTTWCLEzwFbGQSh0LE=;
        b=E+SJ84DeOimnVHb+SYJlIXARrxxkK5dYWIOak0E1PDF9//mZ5jQBd0mbUmtr5GkjOw
         Jl4/7COzWBBVD6qYIRNyFE86nL4wdiYa33eNhLVH9U7lZfReOv5jGSK0Sw0tihucrUhg
         eQEqND+Fpm8rN6o88JlgmwURxnKxvffoLri5maT+Fzm1bASRDWUuDG8YpuXyK5J0Ju+f
         t+cy/CPvPAnoW5Lx4n+cv/rjwp9KB8KZZ0+U/5dRGHaO2wp385kEfkHHAO/5Zz5Nf75O
         h3xxk8vOyIX2Jq0HxkNef0hidUWITRkOruSY6RZB8ObRV+wFJesZCZTXKbCEWHiWjiQf
         DLaw==
X-Gm-Message-State: AC+VfDyhwzwEinnoYBk9l8n3Q9c+sMOCk95ih8skKi/tKx3/qyg9+twy
        mnK5LKdKKY9mrIEfN+P+HRm9HY4KgSU+Qd8DIaCFgQ==
X-Google-Smtp-Source: ACHHUZ4qunQI8u3+yTDkczQEBuTb3LREcEUuuYrGRR2lkK7RzhVrHh93fmgZB4tGW4I3HKHydNAGMm6kDnHUInF7lGs=
X-Received: by 2002:a17:907:2bce:b0:94d:e2ef:1618 with SMTP id
 gv14-20020a1709072bce00b0094de2ef1618mr1984070ejc.7.1682512743467; Wed, 26
 Apr 2023 05:39:03 -0700 (PDT)
MIME-Version: 1.0
References: <20230408164302.1392694-1-amir73il@gmail.com> <20230408164302.1392694-8-amir73il@gmail.com>
In-Reply-To: <20230408164302.1392694-8-amir73il@gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 26 Apr 2023 14:38:52 +0200
Message-ID: <CAJfpegu3HBQyKkUFmYywwKqifwWVO6CYjt3O0WiEdzUirjt9mA@mail.gmail.com>
Subject: Re: [PATCH 7/7] ovl: replace lowerdata inode reference with lowerdata redirect
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Alexander Larsson <alexl@redhat.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, 8 Apr 2023 at 18:43, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Now that we have the entire lower stack in ovl_inode, we do not
> need to hold another reference to the lowerdata inode.
>
> Instead, use the vacant ovl_inode space as a place holder for lowerdata
> redirect path from the metacopy to lowerdata, which is going to be used
> later on for lazy lowerdata lookup.

Seems like this patch is combining two independent changes into one.
Could this be spit into

  - remove lowerdata
  - add lowerdata_redirect

?



> +               /* Store lowerdata redirect for lazy lookup */
> +               if (ctr > 1 && !d.is_dir && !stack[ctr - 1].dentry) {

 So lazy lookup will be signaled with a NULL dentry?  This should be
spelled out in the patch header.

Thanks,
Miklos
