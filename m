Return-Path: <linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42643ECAAD3
	for <linux-unionfs@archiver.kernel.org>; Mon,  5 Sep 2022 13:02:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235793AbiIENCH (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 5 Sep 2022 09:02:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236358AbiIENCF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 5 Sep 2022 09:02:05 -0400
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B06A42715A
        for <linux-unionfs@vger.kernel.org>; Mon,  5 Sep 2022 06:02:03 -0700 (PDT)
Received: by mail-ej1-x632.google.com with SMTP id qh18so16947073ejb.7
        for <linux-unionfs@vger.kernel.org>; Mon, 05 Sep 2022 06:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=VcdyRyCtegAKcibxYT8LV/xntUq1tpWRLDg9uG86Uos=;
        b=qmuBSIi2n4UwSALIvcfvjOkLoarPV+8IdDecPUoWm34+WTRBl/Ti+25Lw/MR1Ek4IV
         TIh9vFRigVzNuPx1yKe2adiIpZLu7SVO+qOtpc2sJE8PaPmPiAjPzsJeD8ITmumHyMKX
         C1F80rp++r1KP5Ce3AZN9KDM7egMD0IBzYtVw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=VcdyRyCtegAKcibxYT8LV/xntUq1tpWRLDg9uG86Uos=;
        b=gRDDn9Y91j6KR+1lIh6e1tyDplItCqrNisc5doyjokBDols2CbPTD2UkzXwWsKfYad
         qWAqwcW0UTlp3LOJNDYgkHAsZdKRmVTlCwjcmquSY9Ot5ha/NTTSff5Y/BeJB/GFXTPq
         Zx7jKH8VdXr7IeALGLkPDrFffSPxEayrhEk0XBM8edLMhlyDdLYzod/8mvdfllY+24Y5
         s/j0ogCRv2/j7ocr6zx2b4Fk+y6hrAExYWl79LTVAMUKdkydQKS2ZqKpzM2PNxA0UIXO
         ltvrc3qPMKJttoD9l3CW1Nc4p7UcpG14FZ6iQ8S8WA6ArUSz+4LaLIcHEcp6XMfjOAKH
         W7vg==
X-Gm-Message-State: ACgBeo3jU7J3E7b8SpttqDowC8TLiICIeAZP/ATHDcU6OEO7pnzrTAOW
        PY+oUNNI8dvhkHcmEoN91Ja5L3+2uJqpoTjg9S8XSg==
X-Google-Smtp-Source: AA6agR6pKhlVRB3+tkv1SWVBt4/MYsIr7KsbA8FliPeUSBlc0kBBJ1LWOxsfeKALbNtBRYTax5HQxwRP0ohhIA3bgYs=
X-Received: by 2002:a17:907:7ea3:b0:741:a1a3:b33a with SMTP id
 qb35-20020a1709077ea300b00741a1a3b33amr22732586ejc.356.1662382922302; Mon, 05
 Sep 2022 06:02:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAB+4eShSNLK6yX6RsdZf=3QE7qUDgpWfKPVV66CDQZ2TZyozHw@mail.gmail.com>
In-Reply-To: <CAB+4eShSNLK6yX6RsdZf=3QE7qUDgpWfKPVV66CDQZ2TZyozHw@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Mon, 5 Sep 2022 15:01:51 +0200
Message-ID: <CAJfpegsGHx51TVMYaNwH8mu3QNh7mTjKPgToVVZFNbeQ1=UzsQ@mail.gmail.com>
Subject: Re: Linux move from aufs to overlayfs fstab configuration issue
To:     =?UTF-8?Q?Miquel_No=C3=A8?= <mnoe@modpow.es>
Cc:     overlayfs <linux-unionfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, 5 Sept 2022 at 13:09, Miquel No=C3=A8 <mnoe@modpow.es> wrote:
>
> Dear Mr Szeredi,
>
> My name is Miquel No=C3=A8, and I work in a small electronic engineering =
company although we also develop software for embedded computers using Debi=
an.
>
> Actually in a Debian 9 we have a fstab file that creates an aufs to set /=
var folder as read-only and all changes goes to tmpfs that are discharted a=
t reboot/shutdown:
>
> tmpfs /var.tmp tmpfs defaults,noatime,nosuid,nodev,exec,mode=3D1777,size=
=3D256M 0 0
> none /var aufs br:/var.tmp=3Drw:/var.ro=3Dro                             =
  0 0
>
> Now I need to update to Debian 11 and aufs has been replaced by overlayfs=
 wich I don't know how to configure to have the same behaviour.
>
> If I add to the new fstab next lines, the result (error reported) is that=
 subfolders /var.tmp/upp and /var.tmp/wrk need to be in the same filesystem=
:
>
> tmpfs /var.tmp/upp tmpfs defaults,noatime,nosuid,nodev,exec,mode=3D1777,s=
ize=3D256M 0 0
> tmpfs /var.tmp/wrk tmpfs defaults,noatime,nosuid,nodev,exec,mode=3D1777,s=
ize=3D256M 0 0
> overlay /var overlay x-systemd.automount,lowerdir=3D/var.ro,upperdir=3D/v=
ar.tmp/upp,workdir=3D/var.tmp/wrk 0 0
>
> If I add to the new fstab next lines, the result is that subfolders /var.=
tmp/upp and /var.tmp/wrk don't exist:
>
> tmpfs /var.tmp tmpfs defaults,noatime,nosuid,nodev,exec,mode=3D1777,size=
=3D256M 0 0
> overlay /var overlay x-systemd.automount,x-systemd.requires=3D/var.tmp,lo=
werdir=3D/var.ro,upperdir=3D/var.tmp/upp,workdir=3D/var.tmp/wrk 0 0
>
> Probably the best soution should be that overlay line in fstab forces to =
create both subfolders, but I don't know how to do that. Can you tell me ho=
w should I create or configure upperdir and workdir in fstab?

One I can think of is creating a /sbin/mount.overlay script that
creates the upper and work directories before proceeding with the
actual mount.

Thanks,
Miklos
