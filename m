From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v6 06/15] ovl: Add helper ovl_already_copied_up()
Date: Fri, 10 Nov 2017 10:24:40 +0200
Message-ID: <CAOQ4uxjTfDnHsA_qNZC+ZFwdNqu4mro_azxkGESQ_VUNR46VRQ@mail.gmail.com>
References: <20171109205019.11409-1-vgoyal@redhat.com> <20171109205019.11409-7-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f181.google.com ([209.85.161.181]:52273 "EHLO
        mail-yw0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751250AbdKJIYl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Nov 2017 03:24:41 -0500
Received: by mail-yw0-f181.google.com with SMTP id w2so7523636ywa.9
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Nov 2017 00:24:40 -0800 (PST)
In-Reply-To: <20171109205019.11409-7-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Nov 9, 2017 at 10:50 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> There are couple of places where we need to know if file is already copied
> up (in lockless manner). Right now its open coded and there are only
> two conditions to check. Soon this patch series will introduce another
> condition to check and Amir wants to introduce one more. So introduce
> a helper instead to check this so that code is easier to read.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

I like it!

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
