From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v6 01/15] ovl: Create origin xattr on copy up for all files
Date: Fri, 10 Nov 2017 08:58:13 +0200
Message-ID: <CAOQ4uxhZ1+1jq=qH=HftbvxduoZT62Md-6zDx-tKfRQZ5R2cNA@mail.gmail.com>
References: <20171109205019.11409-1-vgoyal@redhat.com> <20171109205019.11409-2-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f171.google.com ([209.85.161.171]:53216 "EHLO
        mail-yw0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750860AbdKJG6O (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Nov 2017 01:58:14 -0500
Received: by mail-yw0-f171.google.com with SMTP id w2so7389066ywa.9
        for <linux-unionfs@vger.kernel.org>; Thu, 09 Nov 2017 22:58:14 -0800 (PST)
In-Reply-To: <20171109205019.11409-2-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Nov 9, 2017 at 10:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Right now my understanding is that origin xattr is created for all copied
> up files if index=on. And if index=off, then we create it for all type
> of files except hardlinks (nlink != 1).
>
> With metadata only copy up, I will still require origin xattr to copy up
> data later, so create it even for hardlinks even with index=off.
>
> Given ->origin is always true now, get rid of this field from
> "struct ovl_copy_up_ctx".
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
