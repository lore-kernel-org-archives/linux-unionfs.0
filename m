From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v7 07/14] ovl: Copy up only metadata during copy up where
 it makes sense
Date: Fri, 17 Nov 2017 17:44:39 +0200
Message-ID: <CAOQ4uxheqGOEM=Z0XpP-MN8+qVqU-LoAc7O9mRyxsfNXnx-U+g@mail.gmail.com>
References: <20171116220335.13448-1-vgoyal@redhat.com> <20171116220335.13448-8-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f177.google.com ([209.85.161.177]:40365 "EHLO
        mail-yw0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965470AbdKQPok (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Nov 2017 10:44:40 -0500
Received: by mail-yw0-f177.google.com with SMTP id v75so1418175ywa.7
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Nov 2017 07:44:40 -0800 (PST)
In-Reply-To: <20171116220335.13448-8-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Nov 17, 2017 at 12:03 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> If it makes sense to copy up only metadata during copy up, do it. This
> is done for regular files which are not opened for WRITE and have origin
> being saved.
>
> Right now ->metacopy is set to 0 always. Last patch in the series will
> remove the hard coded statement and enable metacopy feature.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
