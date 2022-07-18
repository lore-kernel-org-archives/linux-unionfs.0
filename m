Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 365F8C433EF
	for <linux-unionfs@archiver.kernel.org>; Mon, 18 Jul 2022 20:13:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231495AbiGRUNJ (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 18 Jul 2022 16:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234862AbiGRUNF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Jul 2022 16:13:05 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4595C2A953
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 13:13:05 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-10c0052da61so26792317fac.12
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 13:13:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b12VQvmMnRuczR7vsiOnnqJ9IYxQ2j6Uskl9KHtzH74=;
        b=ED5cPuZ5ZpUK4tIyvYn/KsjabfMdhC+COgAFRv1mZ0FJmr3Q/Qgmo9ZTWJsnP9e64x
         7BF/LnVuT8/ejVu2S4VUR5xIwDQTdubjq8suLiSGCSj/ZaguEk1VO5rkUzkHipGnqMXb
         nZcvvXrjh9eSXZh4Jn38YXKmpUKVdrstPJhGo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b12VQvmMnRuczR7vsiOnnqJ9IYxQ2j6Uskl9KHtzH74=;
        b=HldOJqxLHfdik9Yo2UdHyKyCKZ9WtDozSvNnz6fmgy228Vj0yK2zaVJbKVUTeVf/Eq
         alwxd8Zf1SFbT7rD3YdIRMZPdGEZ2NuUmFXYbQ7m84cphqe1yiqqDI5/+cRIJHcCWsfG
         p1eSEo5cl33Rq7jVfiNzxQTH3J1Ng103UnGRYNfuGoPBJca0FJEAQ0VJx3B5IfI4uBa0
         XNgZ9O9AjwU7ZQcKorKVMaBmthDq2ouqa6z898WkCt7IuTvL9g8SJt+y76li9gLn4+g9
         qKPYD9e/iBB8OADwH0zLN9Q4jT7l1s29Wxpj5Psqfly1zZ76YHWXakORjn46E5Qn4Xf5
         rTHQ==
X-Gm-Message-State: AJIora9Xib17dshKlRz7AKNU7qfhibuLI7ghWPuVItwtRSQd5pNB9igu
        za04LDWQw98KpDI4FXowK6cByYwqPQgo1tIGLtes5Q==
X-Google-Smtp-Source: AGRyM1t9aWM2H9DFJ+gSWsYZ82wEw6LFKyFCpKROrDGtG3uf9MGg7o5hAAurCdg6UHXBXlkpi3fjkQ==
X-Received: by 2002:a05:6870:c898:b0:10c:6254:a543 with SMTP id er24-20020a056870c89800b0010c6254a543mr15558021oab.103.1658175184517;
        Mon, 18 Jul 2022 13:13:04 -0700 (PDT)
Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com. [209.85.160.41])
        by smtp.gmail.com with ESMTPSA id t26-20020a4ac89a000000b004358b15cfe8sm3021583ooq.13.2022.07.18.13.13.03
        for <linux-unionfs@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Jul 2022 13:13:04 -0700 (PDT)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-10bffc214ffso26851766fac.1
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Jul 2022 13:13:03 -0700 (PDT)
X-Received: by 2002:a05:6870:c1c1:b0:ee:5c83:7be7 with SMTP id
 i1-20020a056870c1c100b000ee5c837be7mr15568709oad.53.1658175183146; Mon, 18
 Jul 2022 13:13:03 -0700 (PDT)
MIME-Version: 1.0
References: <4B9D76D5-C794-4A49-A76F-3D4C10385EE0@kohlschutter.com>
 <CAJfpegs1Kta-HcikDGFt4=fa_LDttCeRmffKhUjWLr=DxzXg-A@mail.gmail.com>
 <83A29F9C-1A91-4753-953A-0C98E8A9832C@kohlschutter.com> <CAJfpegv5W0CycWCc2-kcn4=UVqk1hP7KrvBpzXHwW-Nmkjx8zA@mail.gmail.com>
 <FFA26FD1-60EF-457E-B914-E1978CCC7B57@kohlschutter.com> <CAJfpeguDAJpLMABsomBFQ=w6Li0=sBW0bFyALv4EJrAmR2BkpQ@mail.gmail.com>
 <A31096BA-C128-4D0B-B27D-C34560844ED0@kohlschutter.com> <CAJfpegvBSCQwkCv=5LJDx1LRCN_ztTh9VMvrTbCyt0zf7W2trw@mail.gmail.com>
 <CAHk-=wjg+xyBwMpQwLx_QWPY7Qf8gUOVek8rXdQccukDyVmE+w@mail.gmail.com>
 <EE5E5841-3561-4530-8813-95C16A36D94A@kohlschutter.com> <CAHk-=wh5V8tQScw9Bgc8OiD0r5XmfVSCPp2OHPEf0p5T3obuZg@mail.gmail.com>
 <CAJfpeguXB9mAk=jwWQmk3rivYnaWoLrju_hq-LwtYyNXG4JOeg@mail.gmail.com>
In-Reply-To: <CAJfpeguXB9mAk=jwWQmk3rivYnaWoLrju_hq-LwtYyNXG4JOeg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 18 Jul 2022 13:12:47 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg+bpP5cvcaBhnmJKzTmAtgx12UhR4qzFXXb52atn9gDw@mail.gmail.com>
Message-ID: <CAHk-=wg+bpP5cvcaBhnmJKzTmAtgx12UhR4qzFXXb52atn9gDw@mail.gmail.com>
Subject: Re: [PATCH] [REGRESSION] ovl: Handle ENOSYS when fileattr support is
 missing in lower/upper fs
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     =?UTF-8?Q?Christian_Kohlsch=C3=BCtter?= 
        <christian@kohlschutter.com>,
        overlayfs <linux-unionfs@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jul 18, 2022 at 12:28 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> So this is a bug in the kernel part of fuse, that doesn't catch and
> convert ENOSYS in case of the ioctl request.

Ahh, even better. No need to worry about external issues.

            Linus
