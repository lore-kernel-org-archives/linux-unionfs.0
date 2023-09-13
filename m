Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 418B8EEB593
	for <linux-unionfs@archiver.kernel.org>; Wed, 13 Sep 2023 05:48:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbjIMFsn (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 13 Sep 2023 01:48:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231809AbjIMFsn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 13 Sep 2023 01:48:43 -0400
Received: from mail-ua1-x934.google.com (mail-ua1-x934.google.com [IPv6:2607:f8b0:4864:20::934])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A518172A
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 22:48:39 -0700 (PDT)
Received: by mail-ua1-x934.google.com with SMTP id a1e0cc1a2514c-7a4ee7f9c37so2589987241.0
        for <linux-unionfs@vger.kernel.org>; Tue, 12 Sep 2023 22:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694584118; x=1695188918; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rVaQq5H34HzCJB6tNMArrwWghGjwbZ0X3bd/vh23PFM=;
        b=OwEuuIv/UCts1yF2WgYu+CczK84AGOF2YCjq3+NASJfDjeMXBYBNTVBddvTnDZwPfV
         wGmTcI+HWkxNG2AUkRdsZ3rEwTnxiX9Gjv58poX4WYXsfLnsqLe1g0+4tROIYvxYElXZ
         TvO0f2/SbbQdgNnhV/g+joAwnULb3RWhogxcQUugsYsoge+mVpwfzMzHMjctED4UZVJV
         5XW0nSIbH2SFOoI/IX6guZW47NGevqZO+6RLNWIlPpPWM9XGlfY+XsAQP15cVwasNtkA
         J8N30+IHVPrU2FBUcU7AT727AMHV1/+rec7du0dHkwZwgag46pw9MOV/YnP2Lo7kcddL
         Op3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694584118; x=1695188918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rVaQq5H34HzCJB6tNMArrwWghGjwbZ0X3bd/vh23PFM=;
        b=Y+SQTAqSQ4o/D5xCmTTlcfx1eQda6FaOPbzfnVreUTpTFyOUYVHWSU4c0+bA0qrX2f
         QNe+qG3PN9LdsUdDHR3o5ReQr8CNDw8LXIREOQd45Okplhu+/1iwUUW0/WSw1rGDtS2N
         IEJk+Mmym5q3g7GCLH5dri436YKPZ7hwrzlQU6uxiKj+IraJl+mBuc82SHkOr5MJ0f/B
         kbgHpK5UQXWFCKOmiTllZLRVbXSvY0YhF8X6s12MUpiRLg/hzl8WtWpXrk0BgCtLaT7+
         8ZQJPOXVcdGRLceJqKPGqfReyWY5giOyWEScP/LpZeoefl3em5svgX7LbMCz6SfO8e5a
         hEfQ==
X-Gm-Message-State: AOJu0YzzU35MKrRv5QoWdpZaB3y4xmaqIAqFPlQfMcUZTiT5bQ8gERux
        Gy+ER07maUJ38ARBP7111OY9v61mW15+zGpoRUaEGAYu
X-Google-Smtp-Source: AGHT+IES3tq3miFTKK+U+1BRFhrHsBQZB7fVwKlgqv+NfExbj1Lo+YxJwJq21Jc9mquqS+W2e8Q0HDX+1wi3mpsGEhw=
X-Received: by 2002:a05:6102:904:b0:44d:547d:4607 with SMTP id
 x4-20020a056102090400b0044d547d4607mr1103394vsh.35.1694584117962; Tue, 12 Sep
 2023 22:48:37 -0700 (PDT)
MIME-Version: 1.0
References: <DB6PR01MB373613B9CD1198A409333D77A4F1A@DB6PR01MB3736.eurprd01.prod.exchangelabs.com>
In-Reply-To: <DB6PR01MB373613B9CD1198A409333D77A4F1A@DB6PR01MB3736.eurprd01.prod.exchangelabs.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Wed, 13 Sep 2023 08:48:26 +0300
Message-ID: <CAOQ4uxj-BferL+suXwaQzJm9aT+nqa_C4e2+JRUskUt93wH_Ow@mail.gmail.com>
Subject: Re: Quota on OverlayFS supported?
To:     "Sebert, Holger.ext" <Holger.Sebert.ext@karlstorz.com>
Cc:     "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Sep 12, 2023 at 10:58=E2=80=AFPM Sebert, Holger.ext
<Holger.Sebert.ext@karlstorz.com> wrote:
>
> Hi,
>
> On my system I use OverlayFS. The overlay filesystem is mounted as
> follows:
>
>     mount -t overlay overlay -o lowerdir=3D${ROMOUNT},upperdir=3D${UPPER_=
DIR},workdir=3D${WORK_DIR} ${NEWROOT}
>
> with the variables ROMOUNT, UPPER_DIR, WORK_DIR and NEWROOT pointing
> to the relevant directories.
>
> I tried to activate quota by adding the mount options 'usrquota' and
> 'grpquota' to the above mount command as follows:
>
>     mount -t overlay overlay -o lowerdir=3D${ROMOUNT},upperdir=3D${UPPER_=
DIR},workdir=3D${WORK_DIR},usrquota,grpquota ${NEWROOT}
>
> While I don't get an error,

That's odd. Which kernel/distro are you using?

> the quota tools report that quota isn't
> activated on the (overlay-)filesystem containing the r/w uppder dir.
>
> This makes me wonder whether quotas are actually supported by OverlayFS?
>

No they are not supported.

Thanks,
Amir.
