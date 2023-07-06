Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 314BFEB64D9
	for <linux-unionfs@archiver.kernel.org>; Thu,  6 Jul 2023 07:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229528AbjGFHvu (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 6 Jul 2023 03:51:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233927AbjGFHvt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Jul 2023 03:51:49 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 296EF1BD2
        for <linux-unionfs@vger.kernel.org>; Thu,  6 Jul 2023 00:51:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688629866;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2kVVtIZSoE8S9z1B4caCrql+YqVtIvzxCPgrjGJ9FzM=;
        b=M/KhcobUSVotCWD4mHzH2cI8IhLq0+REX7E/XDBANokSFLXcVn/YX5kKsJtJ3L3r0HUbFu
        KXI3QHWZrHFKLfZg859z8Fmr6cgenYPaCCSvhbUr3Gm0FHJVfwp3qVY8JAPjOQUTFxcOiM
        RxV1UDCCmOHe12wPPJUi3qOhwxLsPoA=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-193-INbtqlc1PM2sTeDeLh8zaA-1; Thu, 06 Jul 2023 03:51:03 -0400
X-MC-Unique: INbtqlc1PM2sTeDeLh8zaA-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-345e7434a79so1672205ab.1
        for <linux-unionfs@vger.kernel.org>; Thu, 06 Jul 2023 00:51:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688629862; x=1691221862;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2kVVtIZSoE8S9z1B4caCrql+YqVtIvzxCPgrjGJ9FzM=;
        b=J3PVc9K7o5SpkuKD0KDHYwNd10KNiWParCoKUE7Dc4SeUqiI3QgKaq8q7DjsDrj+NY
         UCDlvCj/CfiuqEMNbZXMPGXF4LSyxaaVkYY1s9oiu44I/n6kdtAPr3oXaiZS2LkGuDO6
         3h1287VocEA3v7Sm6Ip9Cbv9SYrXaZ9GuzGms5ou5plmm222svq4NTIV3EjWM0Z0hbMO
         XhCKDL2slch/Re2z833pZdemXy020GVtl6kdWM3N+CBXO2QiMVoPa2PL/xhbKfBVO60h
         YHkatW7EZHbrXU1Bk2b+bfVK8owexItJgUgN2gmiAiZHU/bzb4Y2yhuIl5JiF5/lvnFO
         Hvzg==
X-Gm-Message-State: ABy/qLZDTu15mxoD35qjjtvb99g3qcCeabqA+CCXZDEoS/gTkSkqpWip
        r7UxqnnXw9Y/8LuNoXYoTKtQ6pbNXkhnviBxQ+e/9o8OJvm+t+xj0Ns7fsYhRHKpMq3cEusbecS
        Gnn+GSeLYpCgOq0QA+1H35mcBHYMoc2W0d5jB1qAXvg==
X-Received: by 2002:a92:c841:0:b0:346:d51:9922 with SMTP id b1-20020a92c841000000b003460d519922mr1455437ilq.13.1688629862424;
        Thu, 06 Jul 2023 00:51:02 -0700 (PDT)
X-Google-Smtp-Source: APBJJlG7a0GhK3+Saee/CYGqC2wgFg3RwMjVJuW61vfPauNuP+k8RbTpRIBwqBpzenz0FE1yw3OZdau6SJbewpgWgJ4=
X-Received: by 2002:a92:c841:0:b0:346:d51:9922 with SMTP id
 b1-20020a92c841000000b003460d519922mr1455429ilq.13.1688629862197; Thu, 06 Jul
 2023 00:51:02 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686565330.git.alexl@redhat.com> <CAOQ4uxgmV1KKCeq8=8FPkAciwqPpz8JiSM8WEuxDaZbVuYcQ7Q@mail.gmail.com>
 <CAL7ro1EiYOOOqexrKy+UXRzmpGyCaNec3+LHGxnA0YfmoMDN3A@mail.gmail.com>
 <CAL7ro1FKwgUY4e7N_vYi0cFsuVx6St0-oKvcBkiRFnzLH8D1eQ@mail.gmail.com>
 <CAOQ4uxgVnv7wtwFZaBnEotFCwQD1EZcSK2KW4K4vRD8d9fzCiw@mail.gmail.com>
 <CAL7ro1FY6OmhypFGDjinOkkjyJzymntVje4nRA558dKY+KsgzQ@mail.gmail.com>
 <CAOQ4uxjuhzxgTxmRXxczJLDrMzKKr-jzS3R8ESwkw4XQ+UyAfQ@mail.gmail.com>
 <CAL7ro1GYEdMvjn+e8Y8CmMC-s_5NZOXjsj=iv7s5NbnpTZz+Cg@mail.gmail.com>
 <CAOQ4uxjS9mTjCCTS9eS1HmZqKAQV97mh1wpkqJuShCHP_MKqag@mail.gmail.com>
 <CAOQ4uxjNMJG6TQcZiT2sx8eLTyybf+iLR3GtOKaaj7QydVr_0Q@mail.gmail.com>
 <CAL7ro1GhLcPK-xahOVmJAtL5pbgMVm0GVd2xW7tgO+_R4dbD5Q@mail.gmail.com> <CAOQ4uxhiU-y=dMocoSGb75Rze_jOLp82MctB26yFYPT3CMOM3g@mail.gmail.com>
In-Reply-To: <CAOQ4uxhiU-y=dMocoSGb75Rze_jOLp82MctB26yFYPT3CMOM3g@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Thu, 6 Jul 2023 09:50:50 +0200
Message-ID: <CAL7ro1HzspAnCMX-EK3gzaggPqTCEREv1qzeQSTuNhGyM8ESaQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] ovl: Add support for fs-verity checking of lowerdata
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     ebiggers@kernel.org, tytso@mit.edu, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jul 6, 2023 at 9:10=E2=80=AFAM Amir Goldstein <amir73il@gmail.com> =
wrote:
>
> On Mon, Jul 3, 2023 at 11:11=E2=80=AFAM Alexander Larsson <alexl@redhat.c=
om> wrote:
> >
> > Cool, I wanted to look at this, but was on PTO last week.
> > It looks good to me, and I synced this to:
> >   https://github.com/alexlarsson/xfstests/commits/verity-tests
> > To avoid drift.
> >
>
> I pushed the overlay-verity series to overlayfs-next, so you may
> expect "finishing touches" bug reports from bots in the near future.
> As long as they are minor fixes, you can fix your branch and let me know
> and I will update overlayfs-next.
>
> Miklos may yet have feedback on the final version, but I think all his
> comments were addressed including the ACK from Eric (thanks!).

Nice!

> Eric,
>
> There was no posting of v5 that addressed your v4 review comments,
> so we do not have your RVB/ACK for patches 2-4.
> Let me know if you want me to add that to the patches.
>
> Alex,
>
> wrt overlay verity-tests, please submit those tests along with the lowerd=
ata
> tests to fstests anytime between now and the 6.6 merge window.
> The tests are properly equipped to check for the feature and testers can
> use them to test linux-next.

I'll have a look at this soon.

> For test overlay/080 you may add:
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> For test overlay/079 you may retain my authorship or assume authorship
> I don't mind as it was co-authored and you took it to the finish line.
>
> Thanks,
> Amir.
>


--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

