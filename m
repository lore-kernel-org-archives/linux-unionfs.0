Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA1AFC433F5
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Oct 2021 22:38:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C9FFE60E8F
	for <linux-unionfs@archiver.kernel.org>; Thu, 28 Oct 2021 22:38:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhJ1Wka (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 28 Oct 2021 18:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231467AbhJ1Wk3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Oct 2021 18:40:29 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB03FC061570
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Oct 2021 15:38:00 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id m184so10253149iof.1
        for <linux-unionfs@vger.kernel.org>; Thu, 28 Oct 2021 15:38:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=bzvWJuHXgDSwFkimf3eTfgZ//UPutSzsddI3AAUc66c=;
        b=YsxWfTKL0qJAp2l4FKzbr/gwXD/Zx2FnvHiPmfM2+PNgqkVAUJclsZmoPEgyEl1rcy
         IUQG+AFEYgc5g44O1fW/UXkt1uQN4s9VZ1QOYK1CnqnLju0nEJfZe0Ui5RJdk0CrxoL+
         8DtABIgERJRfqEipsIrSFriMcmc6/H6NhYEEXC+8f7zhUK1UWE/jnVq9D6Lh1YxuE2w0
         +/MRhHqv8Vx6OZQ4cXk8wHGARzmr3gN0iQ6KuXSifzxES9lbv2oED0u8m3ZHSrXkNtAj
         y9d88XoAbmnwJiAes15kLF/g+2CIRNvIyFuy3w3pf67I6EraukHOyFg2YcN2jlb9Bvuq
         3Fng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=bzvWJuHXgDSwFkimf3eTfgZ//UPutSzsddI3AAUc66c=;
        b=ed7DtAvQGSVTVUL/j6+yKudaCJLeIbvtLZj4DDSl5z5egLwX9qoI4wdOH03OJhVwAn
         jhSj6U6amzac8uC9vsD7rJJm3iRmwbp6xtiD5DITIgDYlz/Xo7eWcdV0G44TFD/dLzJL
         FThgTrOCH0A23cUvWCqelIg56M9O8YMMKAdEyjKih+LnVTkB6oJwGfGBmNu8eIU1bvdk
         Oc1jOlzbNOUglSkjYMAqqNeLAv0/OyOTtKc1ft1TMJPQYjcnMc0IaXurt5P9lhx2evhd
         9IHmz9IAYXrJqvhLjaLGTfuQE1UkqZR2e3xIpfMtWdNY9RUrBvGk70lTKOQ5+dy1F0P6
         lKdA==
X-Gm-Message-State: AOAM531b8xOo3DkJLiKPQizCuROfeIGpE7kxLir8n+uJyIz4V7mJxdrV
        10civgJfA76TA3L9CD2n2fvGo/Y/vnRBsxLhuE8=
X-Google-Smtp-Source: ABdhPJyJxP2BxlK40B6mSZG/XhLTUZ9MXFfRD+fiO5jTmQ7P8F0nFm249HiccDe0JRfpeE7DJPl/PgJG8eN7j9gWVnQ=
X-Received: by 2002:a5e:c743:: with SMTP id g3mr5192189iop.196.1635460680168;
 Thu, 28 Oct 2021 15:38:00 -0700 (PDT)
MIME-Version: 1.0
References: <951c68ed-3f0e-8d9b-6c10-690df778ecc2@gmx.net>
In-Reply-To: <951c68ed-3f0e-8d9b-6c10-690df778ecc2@gmx.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 29 Oct 2021 01:37:49 +0300
Message-ID: <CAOQ4uxh_P0fiV9gQOs9CLvB+xJpJT4hWfAFyKBx0A-TyxAma8Q@mail.gmail.com>
Subject: Re: overlayfs: supporting O_TMPFILE
To:     =?UTF-8?Q?Georg_M=C3=BCller?= <georgmueller@gmx.net>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Oct 28, 2021 at 11:41 PM Georg M=C3=BCller <georgmueller@gmx.net> w=
rote:
>
> Hi,
>
> I was trying to implement .tmpfile for overlayfs inode_operations to supp=
ort O_TMPFILE.
>
> Docker with aufs supports it, but this is deprecated and removed from cur=
rent docker. I now have a work-around in my code (create tmpfile+unlink), b=
ut
> I thought it might be a good idea to have tmpfile support in overlayfs.
>
> I was trying to do it on my own, but I have some headaches to what is nec=
essary to achieve the goal.
>
>  From my understanding, I have to find the dentry for the upper dir (or w=
orkdir) and call vfs_tmpdir() for this, but I am running from oops to oops.
>
> Is there some hint what I have to do to achieve the goal?
>

You'd want to use ovl_create_object() and probably pass a tmpfile argument
then pass it on struct ovl_cattr to ovl_create_or_link() after that
it becomes more complicated. You'd need ovl_create_tempfile() like
ovl_create_upper().
You can follow xfs_generic_create() for some clues.
You need parts of ovl_instantiate() but not all of it - it's a mess.

Good luck!
Amir.
