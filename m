Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA4A8EB64DA
	for <linux-unionfs@archiver.kernel.org>; Mon, 26 Jun 2023 13:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbjFZNBt (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 26 Jun 2023 09:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230514AbjFZNBl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 26 Jun 2023 09:01:41 -0400
Received: from mail-vs1-xe34.google.com (mail-vs1-xe34.google.com [IPv6:2607:f8b0:4864:20::e34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A879A0
        for <linux-unionfs@vger.kernel.org>; Mon, 26 Jun 2023 06:01:40 -0700 (PDT)
Received: by mail-vs1-xe34.google.com with SMTP id ada2fe7eead31-4436dc265d6so173919137.0
        for <linux-unionfs@vger.kernel.org>; Mon, 26 Jun 2023 06:01:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687784499; x=1690376499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WmCzRPzRcTg1NKOs+w+vHzLQv/9uj8XhgnwGLZnfWp0=;
        b=Pyn+5ySoU2fm4WO5QNddAMphfHi5U06M8WWy+EMSnNBrfdDGmSc38BAWSJ4oeXxiuK
         5UysN/vhKAu5gwCRr1P6KtS0vAblcl8b/tlvQDlF2Z9nsarIyDB+LS++OYxbmfVOSZEY
         icTTAfXcH+khRFtWETQ1JjTidv12yX0vhrDPpDP6J4xs3ctVmVyNUo7rKt3LuVKwnbzt
         k6kNRCAkt7YTA4uB3N16GQa+jeQHrB3NSi58J/tfkkZ/da1Onq3/10nfnklDCWijC1Bu
         N6nidNDMf3bcdqMUYpzbHD559QRUszKI9TNA9YDGNkpL8hi+3CX19FDzbysLWRud7ePr
         5P1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687784499; x=1690376499;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WmCzRPzRcTg1NKOs+w+vHzLQv/9uj8XhgnwGLZnfWp0=;
        b=e6p9qWlaZtABDVPgf9SUNnvUVQrj+OEBGfqv37UmtBN7RaciXl4HslQ3ArOVxtR7+k
         hDrdfou79/4XmxajKT+IVzHLmjIxumfg1/p1JjQqxhL8DEo8EFMIgKcepDhr0Ylq5WmO
         6sREKMmtkqfoxD9gER9he5Huu2ZkqbFJmaZQbqRhMKoOwmP2EMYxsn2iV/9ZZpjdUD8R
         KIQuHtW8OJFwP+1kL7ySiTbSyTskdPu1/wvveFnOHP179cBePhs74AzsWxBWJv45L57u
         Otss6vOdO5QkE8WTyHhFoIjD6zJVGsYn0IMtWaQKok2DxTC4nTyb+kEmtDTTYHbIQbuL
         5zGQ==
X-Gm-Message-State: AC+VfDzh1xwQXX/a8Fk55+XDVO9KawNPcIsCw6nEPXAT7Ugn7MSVPeVD
        0YPmu86xHM6MFd2nP54QaPNAAG1E5und3t51O1sVydDawBU=
X-Google-Smtp-Source: ACHHUZ6cYnKNdhihXPX3jbprEGnNZnxHQYL6ie+bTRZ/0neTXabzJBSTR1gMDqCgEM53L4nl6DooMkjUQH439RnE4Ag=
X-Received: by 2002:a67:f044:0:b0:43f:437e:da70 with SMTP id
 q4-20020a67f044000000b0043f437eda70mr9300564vsm.0.1687784499246; Mon, 26 Jun
 2023 06:01:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1686565330.git.alexl@redhat.com> <CAOQ4uxgmV1KKCeq8=8FPkAciwqPpz8JiSM8WEuxDaZbVuYcQ7Q@mail.gmail.com>
 <CAL7ro1EiYOOOqexrKy+UXRzmpGyCaNec3+LHGxnA0YfmoMDN3A@mail.gmail.com>
 <CAL7ro1FKwgUY4e7N_vYi0cFsuVx6St0-oKvcBkiRFnzLH8D1eQ@mail.gmail.com>
 <CAOQ4uxgVnv7wtwFZaBnEotFCwQD1EZcSK2KW4K4vRD8d9fzCiw@mail.gmail.com>
 <CAL7ro1FY6OmhypFGDjinOkkjyJzymntVje4nRA558dKY+KsgzQ@mail.gmail.com>
 <CAOQ4uxjuhzxgTxmRXxczJLDrMzKKr-jzS3R8ESwkw4XQ+UyAfQ@mail.gmail.com>
 <CAL7ro1GYEdMvjn+e8Y8CmMC-s_5NZOXjsj=iv7s5NbnpTZz+Cg@mail.gmail.com> <CAOQ4uxjS9mTjCCTS9eS1HmZqKAQV97mh1wpkqJuShCHP_MKqag@mail.gmail.com>
In-Reply-To: <CAOQ4uxjS9mTjCCTS9eS1HmZqKAQV97mh1wpkqJuShCHP_MKqag@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Mon, 26 Jun 2023 16:01:28 +0300
Message-ID: <CAOQ4uxjNMJG6TQcZiT2sx8eLTyybf+iLR3GtOKaaj7QydVr_0Q@mail.gmail.com>
Subject: Re: [PATCH v3 0/4] ovl: Add support for fs-verity checking of lowerdata
To:     Alexander Larsson <alexl@redhat.com>
Cc:     ebiggers@kernel.org, tytso@mit.edu, miklos@szeredi.hu,
        linux-unionfs@vger.kernel.org, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Jun 22, 2023 at 2:45=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Thu, Jun 22, 2023 at 12:52=E2=80=AFPM Alexander Larsson <alexl@redhat.=
com> wrote:
> >
> > On Thu, Jun 22, 2023 at 11:37=E2=80=AFAM Amir Goldstein <amir73il@gmail=
.com> wrote:
...
> > > Alex,
> > >
> > > Verified that your verity-tests2 work as expected with v5 patches.
> >
> > To be honest I have not validated that my changes to the shared verity
> > code still works with the non-overlayfs tests. If you have a setup for
> > it it would be great if you could try the regular ext4 w/ fs-veriy
> > tests on top of the verity-test2 branch.
> >
>
> There is no problem with "./check -g verity" on ext4
> those tests pass.
>
> However, "./check -overlay -g generic/verity" fails several test:
> Failures: generic/572 generic/573 generic/574 generic/575 generic/577
> because _require_scratch_verity falsely claims that overlay (over ext4)
> supports verify, but then FS_IOC_ENABLE_VERITY actually fails
> during the test.
>
> Instead of changing _require_scratch_verity() as you did,
> you should consider passing optional arguments, e.g.:
>   local fstyp=3D${1:-$FSTYP}
> and calling it from _require_scratch_overlay_verity() with the
> $OVL_BASE_* values.
>

FWIW, I pushed this solution to
https://github.com/amir73il/xfstests/commits/verity-tests

It's ugly, but it works.

Thanks,
Amir.
