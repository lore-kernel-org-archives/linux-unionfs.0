Return-Path: <SRS0=W3VS=6O=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C0FC8300A
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Apr 2020 12:22:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39BAC2078D
	for <linux-unionfs@archiver.kernel.org>; Thu, 30 Apr 2020 12:22:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ctfKtndA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgD3MWT (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 30 Apr 2020 08:22:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726520AbgD3MWS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 30 Apr 2020 08:22:18 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FCBCC035494;
        Thu, 30 Apr 2020 05:22:18 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id k6so1214773iob.3;
        Thu, 30 Apr 2020 05:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hwZCgyJV3kaCAeH+ZFgIw/Qn7OWCSNy7C0ZHnqSSvQI=;
        b=ctfKtndAwDxBVkjSXcjV200G1JEY1vvpCuSCO5x/E9RJHZXWXJK9gGnfZmUiAgA7nL
         5StX4dgdiiU21SVVLZgAgxzkEh39QHMNOX+1saYlnqzDOptfQQKBuXF+SKbicYRqBvfR
         gnTDLREbGUETfmtwx+ghN7XPVgdeoRF36JYcKpUK7jjZvnAkvjNvBCIc0EzlZpMjI/ta
         yYOz7u+DZEGXer7qFDxrjN4NXY3DV8Iaac+669Pdg77MjjaWA1tfVf1p3I9TpTpLt9Ia
         4EIwmtfSdGTFW8Evrf/+KJaK6Izjn5/VSYT0wyulAVm+x43FZqI00ZmubYqs/5CLhIKL
         kwwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hwZCgyJV3kaCAeH+ZFgIw/Qn7OWCSNy7C0ZHnqSSvQI=;
        b=mTViZXDHYVezqZkC0xVI2C45g3RoY2Wd2G+5tVwvxwvrC/yOul4enzy/pB6aerkDZ1
         BzMJ3a6QluF+vLIpKG2nwqYQH+uMWZcOryAe8xeLTqOdBs9zKdwV63wQKuDqiyxsB8C/
         nFu76Ps5CKQpSCzvywL9vo7wejHrB13pIKiRot0v/kEibFnxZhNtOQ8uV+/+CkdU7N44
         vvKvqIEp5GEMRrcms4BH1x/rCq9+c89/08Vol9ekS9qRcGh4BdqgmbVN1t1PAoQPtSBi
         UZYNkVW6fJNRpzLhgVp1e4tJPQywq3DVuQJdCnudz+f0dKQwV9get/2IxX7RFlDFT010
         tueg==
X-Gm-Message-State: AGi0PuYXQAKYtqHDa9auOuwaAn/cExAoN3Q9sBWwX9Wh7U38vhdXrxsd
        gdvxrJoi5fbOZ4t2Ay12xbLG5uS1N+ZfkeG+UIWczNiI
X-Google-Smtp-Source: APiQypIMeBvag/x0b9lXOobALF8czDdCb9AcuAATlvLpmbjtU1HalsA/uZk/WjhctyOaNu+IFaqT7Weo3jemIR2jhac=
X-Received: by 2002:a5e:a90a:: with SMTP id c10mr1572257iod.64.1588249337218;
 Thu, 30 Apr 2020 05:22:17 -0700 (PDT)
MIME-Version: 1.0
References: <171ca5e76d2.11a198ab91526.7776557945472155733@mykernel.net> <171ca7ca308.ed1c416b1605.5683082771269054301@mykernel.net>
In-Reply-To: <171ca7ca308.ed1c416b1605.5683082771269054301@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 30 Apr 2020 15:22:06 +0300
Message-ID: <CAOQ4uxgVRW9QKVg8edem2OKH1cjLF1+h5YW+nPfkoQg3OiaxgQ@mail.gmail.com>
Subject: Re: system hang on a syncfs test with nfs_export enabled
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     linux-unionfs <linux-unionfs@vger.kernel.org>,
        fstests <fstests@vger.kernel.org>, miklos <miklos@szeredi.hu>,
        guaneryu <guaneryu@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Apr 30, 2020 at 12:48 PM Chengguang Xu <cgxu519@mykernel.net> wrote=
:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-04-30 17:15:20 Chenggua=
ng Xu <cgxu519@mykernel.net> =E6=92=B0=E5=86=99 ----
>  > Hi
>  >
>  > I'm doing some tests for my new version of syncfs improvement patch an=
d I found an
>  > interesting problem when combining dirty data && godown && nfs_export.
>  >
>  > My expectation  is  Pass or Fail  all tests listed below, Test2 looks =
a bit strange and in my
>  > opinion there is no strong connection between nfs_export/index and dir=
ty data.
>  > Any idea?
>  >
>  >
>  > Test env and step like below:
>  >
>  > Test1:
>  > Compile module with nfs_export enabled
>  > Run xfstest generic/474   =3D=3D> PASS
>  >
>  > Test2:
>  > Compile module with nfs_export enabled
>  > Comment syncfs step in the test
>  > Run xfstest generic/474   =3D=3D> Hang
>  >
>  > Test3:
>  > Compile module with nfs_export disabled
>  > Run xfstest generic/474   =3D=3D> PASS
>  >
>  > Test4:
>  > Compile module with nfs_export disabled
>  > Comment syncfs step in the test
>  > Run xfstest generic/474   =3D=3D> FAIL
>  >
>
> Additional information:
>
> Overlayfs version: latest next branch of miklos tree (5.7-rc2)
> Underlying fs: xfs
>

Please test also against 5.7-rc2. Maybe we introduced some
regression in -next.

Please dump waiting processes stack by echo w > /proc/sysrq-trigger
to see where in kernel does the test hang.

I cannot think of anything in nfs_export/index that should affect
generic/474, but we will find out soon...

Thanks,
Amir.
