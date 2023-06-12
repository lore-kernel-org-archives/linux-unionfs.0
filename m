Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59501C7EE2F
	for <linux-unionfs@archiver.kernel.org>; Mon, 12 Jun 2023 14:56:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238250AbjFLO4s (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 12 Jun 2023 10:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238356AbjFLOy5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 12 Jun 2023 10:54:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F34C2CD
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2023 07:54:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686581647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pIq65nhbapIlNGOmTQ9RE9QAfyaHMJANHZt0h3eD1Sw=;
        b=QY0zvzRyptGjitCHMOEMutpn5wSFOGsLgbY/oTvTgd+bVh9dVkr1LR+7V7TTZ//K/X9VOU
        6RtiXO9D0vBGRyY/Wcffxge/y1ypyctPx5eUnSsGkmYe2uVszfMhfq+k4xd8Oi2GBus+gt
        KbT/YqhXFvlMrQmifvEPguvMDG8jqog=
Received: from mail-io1-f72.google.com (mail-io1-f72.google.com
 [209.85.166.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-569-AhEIgp_XPk-B_oEyInQsFA-1; Mon, 12 Jun 2023 10:54:06 -0400
X-MC-Unique: AhEIgp_XPk-B_oEyInQsFA-1
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-77accdaa0e0so450974939f.0
        for <linux-unionfs@vger.kernel.org>; Mon, 12 Jun 2023 07:54:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686581645; x=1689173645;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pIq65nhbapIlNGOmTQ9RE9QAfyaHMJANHZt0h3eD1Sw=;
        b=j9BDpGB1ISYsNthh3W2bhNBFApl4IY2L1TnxIpJK/nOkfsIWX4JARABmXXnJSdOwiS
         hZpWALLDjRPleqirOavTeQHVK8K+PvNaqYtdevojFu+C9mMq054ga8YtciJe2UrBrxFd
         l7/AeD0KmVB6b8VjPmojv3enkAZBF9auANx7mzffbP2CAZMZv5mg7bJpHYGhcfT3zXG0
         i04nVkrFraS9R/KokIhkUwtRr2szPfVrntHS0p7Tb70btlK6R9S6ikskRlrmHyf0TXYv
         MP72iowIXNQNQwZtUPmjrK2QhrVCnDwuR0wtM2bx8yi/rfUNulNAzRCIJY+6/JnXw8D1
         yPxw==
X-Gm-Message-State: AC+VfDx2uR/2FwNlTa5Bwgazstn5COQ35y/dfCOvZ69x8hpmrgPwhpnm
        Rtyc/S5gQdW2wS+Qd7B8nyWi0qCW4popDV5mYp0cF8OY3fU5rrZ0rzlFbDuSPFUes9FrSALt5hD
        52eoyu059hbd+zNRTNqjj6As1F0N5KxDIDjFnL3nNZETMC/8FaQ==
X-Received: by 2002:a92:dac5:0:b0:335:fc8:9b4 with SMTP id o5-20020a92dac5000000b003350fc809b4mr7760626ilq.19.1686581645535;
        Mon, 12 Jun 2023 07:54:05 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7/JtVsEvI5+bRqZI+OFWwwEpS5GPhyl9aMhmgJ12/OJ7wPGuWZlkJh0gdz2ngmVOk/PFY19NmDBBTQMzlC1A0=
X-Received: by 2002:a92:dac5:0:b0:335:fc8:9b4 with SMTP id o5-20020a92dac5000000b003350fc809b4mr7760618ilq.19.1686581645321;
 Mon, 12 Jun 2023 07:54:05 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686565330.git.alexl@redhat.com> <CAOQ4uxgmV1KKCeq8=8FPkAciwqPpz8JiSM8WEuxDaZbVuYcQ7Q@mail.gmail.com>
 <CAL7ro1EiYOOOqexrKy+UXRzmpGyCaNec3+LHGxnA0YfmoMDN3A@mail.gmail.com>
In-Reply-To: <CAL7ro1EiYOOOqexrKy+UXRzmpGyCaNec3+LHGxnA0YfmoMDN3A@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Mon, 12 Jun 2023 16:53:54 +0200
Message-ID: <CAL7ro1FKwgUY4e7N_vYi0cFsuVx6St0-oKvcBkiRFnzLH8D1eQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] ovl: Add support for fs-verity checking of lowerdata
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Jun 12, 2023 at 1:09=E2=80=AFPM Alexander Larsson <alexl@redhat.com=
> wrote:
>
> On Mon, Jun 12, 2023 at 12:54=E2=80=AFPM Amir Goldstein <amir73il@gmail.c=
om> wrote:
> >
> > On Mon, Jun 12, 2023 at 1:27=E2=80=AFPM Alexander Larsson <alexl@redhat=
.com> wrote:
> > >
> > > This patchset adds support for using fs-verity to validate lowerdata
> > > files by specifying an overlay.verity xattr on the metacopy
> > > files.
> > >
> > > This is primarily motivated by the Composefs usecase, where there wil=
l
> > > be a read-only EROFS layer that contains redirect into a base data
> > > layer which has fs-verity enabled on all files. However, it is also
> > > useful in general if you want to ensure that the lowerdata files
> > > matches the expected content over time.
> > >
> > > I have also added some tests for this feature to xfstests[1].
> >
> > I can't remember if there is a good reason why your test does
> > not include verify in a data-only layer.
> >
> > I think this test coverage needs to be added.
>
> Yeah. I'll add that.

Updated the git branch with some lowerdata tests.

=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

