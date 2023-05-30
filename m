Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC86C77B73
	for <linux-unionfs@archiver.kernel.org>; Tue, 30 May 2023 14:15:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbjE3OP4 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 30 May 2023 10:15:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbjE3OPz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 30 May 2023 10:15:55 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FF51A2
        for <linux-unionfs@vger.kernel.org>; Tue, 30 May 2023 07:15:30 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id a1e0cc1a2514c-786d10951d8so1305105241.3
        for <linux-unionfs@vger.kernel.org>; Tue, 30 May 2023 07:15:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685456128; x=1688048128;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HadSdWrukqdbBt43//k/Q4boeRw3eTi2aTbyslqwByo=;
        b=h6WXLDaRtJCJIPVxVHit4LGR5cInwGm1PmYSJDaBRQH8xsBnQB9JiPmebLX5D4uxDp
         VD1kc1GLqGdtEgYg02bt/kqY1HCbc/JfaRJCK2ZivAKEHx8sUmhZctXZ7HiRnPvlEueF
         E6yYW0NRyx64LJqqYNy7oadJHzHPepKX7IujBq+HNcu49MgklEuJz8wUxlEGRin+mgHu
         S+JzRcq/Tv5r/auS9kbigTOTjotpIMOvHJpewllm8sVmtai7mCB8VBJCyrYA0mx2Pcvv
         vsmzpt/8QLreT5dxAByWMgSt7elc7aKH6JLU5lcCAS8qkqUlREMRkeJdQ4W2S/62HUyI
         P+ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685456128; x=1688048128;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HadSdWrukqdbBt43//k/Q4boeRw3eTi2aTbyslqwByo=;
        b=iUBBCt6n3kYJvmC3rTu123hEJu/2rFqQg+P9K/l0h31kv9RmamYQfcQRPg9ZOmiX9O
         9S7poFr+qazV7VgzEd+XFhnLLDxQM1vG7CC5o1ss4jbAWKI3O6o4SugBDNUgxIQy/8F0
         WX0rWRMD9gF7WQxC3xzjhtIT7l2jLSfJHns/tE6gEoXQdS/h+fzjEJTt4n3g7BFQaCvh
         Af4LT3oshs2BucjSqkUsR++zoSnUP1fVVysLDXeXU1SKVXhWer8nI8CrTQtP27I7vWsw
         fQ4ZYFq/Ufm8pfWWcZKmgeAfonMWP4sNopH3KxM8VdoFbqPhzICdZnaJj3xHp+CUL5Pw
         B67A==
X-Gm-Message-State: AC+VfDwZKNX5puaXSSzjo6JGQPTkc2ZOkTKMjG5+F8fqBU1jsvfiSVeo
        Nh0qrONBhWfUh8EdUR+pbHWfvXuRNFduTo0e8OHYe1vWGEU=
X-Google-Smtp-Source: ACHHUZ6I++Y1ZdrHwsYogtDx00wuyjWJWCNN1j6mmHHStj9C4DjbX0GLBZpwDHTRfJuzWAsG/lBlxmtyYnnF7ghPmHw=
X-Received: by 2002:a67:fe8c:0:b0:434:70b4:b356 with SMTP id
 b12-20020a67fe8c000000b0043470b4b356mr854784vsr.28.1685456128025; Tue, 30 May
 2023 07:15:28 -0700 (PDT)
MIME-Version: 1.0
References: <20230427130539.2798797-1-amir73il@gmail.com> <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
 <CAOQ4uxhN1dPBkhAu3Zag8=RKCbzMQghuXnyp+uur83dRW8tz6Q@mail.gmail.com>
 <87h6s0z6rf.fsf@redhat.com> <CAOQ4uxhkCgU2=F2oAJn34Jor2_Hr56fLsa8cAAz936G05d-+ZQ@mail.gmail.com>
 <CAL7ro1EoNDMxU2d9WYrb772VFWWMDWV=KVvrZDnK=5byemmo8Q@mail.gmail.com>
 <fb711bb4-3f25-ccee-0d21-2cb6deea75ec@linux.alibaba.com> <CAOQ4uxiCzTbr4OXhxv=RbNbKn+kaBva-Wkz4AGW8OJUwL3GfLQ@mail.gmail.com>
 <CAJfpegvsEuSNepb_9MNEkEFsW7R60DDk57x3oivA6wx9y8StRA@mail.gmail.com>
In-Reply-To: <CAJfpegvsEuSNepb_9MNEkEFsW7R60DDk57x3oivA6wx9y8StRA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Tue, 30 May 2023 17:15:16 +0300
Message-ID: <CAOQ4uxh14O9aRiewc+nq+AL-029YGu4bb4AZpp854r78Jm=_dw@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Gao Xiang <hsiangkao@linux.alibaba.com>,
        Alexander Larsson <alexl@redhat.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        linux-unionfs@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, May 30, 2023 at 5:08=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Sat, 27 May 2023 at 16:04, Amir Goldstein <amir73il@gmail.com> wrote:
>
> > If we would want to support data-only layers in the middle on the
> > stack, which would this syntax make sense?
> > lowerdir=3Dlower1::data1:lower2::data2
> >
> > If this syntax makes sense to everyone, then we can change the syntax
> > of data-only in the tail from lower1::data1:data2 to lower1::data1::dat=
a2
> > and enforce that after the first ::, only :: are allowed.
> >
> > Miklos, any thoughts?
> > I have a feeling that this was your natural interpretation when you fir=
st
> > saw the :: syntax.
>
> Yes, I think it's more natural to have a prefix for each data-only
> layer.  And this is also good for extensibility, as discussed.
>

Good timing ;-)

I was just about to say that I changed the syntax and pushed to:

https://github.com/amir73il/linux/commits/ovl-lazy-lowerdata-v3
https://github.com/amir73il/xfstests/commits/ovl-lazy-lowerdata

The gist of the documentation of v3 is:

Below the top most lower layer, any number of lower most layers may be defi=
ned
as "data-only" lower layers, using double colon ("::") separators.
A normal lower layer is not allowed to be below a data-only layer, so singl=
e
colon separators are not allowed to the right of double colon ("::") separa=
tors.

For example:

  mount -t overlay overlay -olowerdir=3D/l1:/l2:/l3::/do1::/do2 /merged


Do you need me to post the v3 patches?

The changes since ovl-lazy-lowerdata-v2 branch are:
- Reabse on 6.4-rc2 + NULL deref fixes
- Syntax change

Thanks,
Amir.
