Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD269C30624
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Aug 2023 14:46:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352189AbjHQOqL (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Aug 2023 10:46:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352352AbjHQOp7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Aug 2023 10:45:59 -0400
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C5FA3A8B
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 07:45:45 -0700 (PDT)
Received: by mail-vs1-xe2c.google.com with SMTP id ada2fe7eead31-44bf15d88f5so501306137.2
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 07:45:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692283544; x=1692888344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sRsskbvlEN5oQlKxnXeGt7b1C3BDLjpxjEHa03ZXxMQ=;
        b=rivEk9MP7XKlNQdkrApHgg3IVXrTGGC1Za3XtGMhH9E1/TbFDDAW00s5XuEtNLurkN
         aGPa5NpdlRzeAjwB3HVmL4V5RfmprGoEeC4R0eq7hcndLCkFaNyn/T+gL3bGZPj34Kiz
         y++Zb0ivB2wSh8Xa0Wgr/60AM1mpope90vus0AZDfZX3/zmciEM57lOosj91hKpCVw5z
         tbs+6+FzdmN0InjpuhCCyEqLAr5RB8qP/0/M5P0cQOWvGGVN8XytPjRIfaLiikzVUeLz
         9klvguiP+a21GPCpKQPjNyuZJrCwGAVBnLsfbecQ0AFArWiQzPFoSe7l3Xcfc5i524sB
         QZGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692283544; x=1692888344;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sRsskbvlEN5oQlKxnXeGt7b1C3BDLjpxjEHa03ZXxMQ=;
        b=E9RbYME/qaDRyrIi09tWUoEQaUW6NC+yaK2+jlUf4eX3VPDiy4QV7eWTr8d4k/v09y
         8VOGWjpeEZZMadANwDupTQwfZF4BTm7EQDK53P8vf75zQbVLgmqR1Rj9/OF+9G2Lmvx6
         sVPzOGzeFGEhkLEsPdpgk5QiKcAonOu+CZnGL9j5cO/VTU7UlmdBXLdHrt8f2yaevv1K
         aG5mrR+6GGwQH6Wl3LkpeBiN0+doKLj1QyfUm3ZjH4oO2QL9JWiEcbnsVEIktBpv9FJm
         H+UoW7KpMkyONOQsZEbx9FeDkC+IDc7F848wC1eIqVeMQhaYU1sVbl/SSzxssYaSXeXA
         lS+w==
X-Gm-Message-State: AOJu0YzYZh1bd7jww4GlHlkNOW2STHt2DB7KU+JQyxZZlan+MzVfBzc5
        LWZojeUYOZ97igWSQQl3/AWjDtjIw2xcEGGNPo0=
X-Google-Smtp-Source: AGHT+IHVpuRk/i0g8Dk3MFsTOKUfVxSzsDf/iR7zZE7Dh417/Sdye+P9E+SKiRP5+efkJC7tuYEmddQRf2VZVQlkbHM=
X-Received: by 2002:a67:ce04:0:b0:447:530d:fc02 with SMTP id
 s4-20020a67ce04000000b00447530dfc02mr3806967vsl.22.1692283544209; Thu, 17 Aug
 2023 07:45:44 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com>
In-Reply-To: <cover.1692270188.git.alexl@redhat.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 17 Aug 2023 17:45:32 +0300
Message-ID: <CAOQ4uxhUz7tMnrSbmTxXB=6jaRHdbnDLtkXtfsTYJd-azHdCtw@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] Support nested overlayfs mounts
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Aug 17, 2023 at 2:05=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> There are cases where you want to use an overlayfs mount as a lowerdir fo=
r
> another overlayfs mount. For example, if the system rootfs is on overlayf=
s due
> to composefs, or to make it volatile (via tmps), then you cannot currentl=
y store
> a lowerdir on the rootfs, becasue the inner overlayfs will eat all the wh=
iteouts
> and overlay xattrs. This means you can't e.g. store on the rootfs a prepa=
red
> container image for use using overlayfs.
>
> This patch series adds support for nesting of overlayfs mounts by escapin=
g the
> problematic features on and unescaping them when exposing to the overlayf=
s user.
>
> This series is also available here:
>   https://github.com/alexlarsson/linux/tree/ovl-nesting
>
> And xfstest to test it is available here:
>   https://github.com/alexlarsson/xfstests/tree/overlayfs-nesting
>

Hi Alex,

Technically, the patches look pretty sane to me.
I'll need Miklos to weight in on the review as well and anyway
I think we should get verity merged (to 6.6) before considering this
(sort of) follow up.

I'd add some more tests as I commented on github including
mixing user and trusted xattr use case.

Thanks,
Amir.
