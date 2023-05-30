Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5051C77B73
	for <linux-unionfs@archiver.kernel.org>; Tue, 30 May 2023 14:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjE3OJC (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 30 May 2023 10:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbjE3OI4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 30 May 2023 10:08:56 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6705133
        for <linux-unionfs@vger.kernel.org>; Tue, 30 May 2023 07:08:51 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2af2c7f2883so47490871fa.3
        for <linux-unionfs@vger.kernel.org>; Tue, 30 May 2023 07:08:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1685455730; x=1688047730;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SDUPcDITSaPdMmejF0pB7IAOxrsYO9EqbKwCajIRRyI=;
        b=ik5vEeEysyKYUQLLx0DGbSt7g2Yzmzp6ZM1aXJR0NwUaBEuOW/ZzF6pjwqeUFP5S79
         pG74TysVb9pJiPMnIPQlMvJbAnhO514V9hpI+DQiU2poYdztm2MBwqNhKxg/QpCz1FsI
         otVw3LIlswbgPDbGDy2nXHt9WJ0aZK0bmuXXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685455730; x=1688047730;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SDUPcDITSaPdMmejF0pB7IAOxrsYO9EqbKwCajIRRyI=;
        b=MhZuhDkOyl9wamdmJO3Iv4hiJ9xBW89CKrLFLKs4bSs7o/UEfMaQjzRuACoBC9QQkf
         k6dtzBsZlxcTdCm/U5j+avF9/Ao3uo2YbhfIIw5clS03MiAl3fO1EXIqILV0IPMKERPn
         1OdgrykcltPjEr3F9E6kmhphW3h0eraN7rIxlG+IzBzDSsmifKd6rKAVZKfMAJBW2EYc
         JyHiJKwKEwhP1EWB/ids+Yj9izgtmlMySDuK3CKw/L1uxK5SCaL/n4DfJavVFuav9+p8
         BytOU6aJW2lUxEO4p8xgPomh9m1fZq64xaKaypv65tvDMNtNVgjeLnO4JAcrBmZeTq48
         kzFw==
X-Gm-Message-State: AC+VfDzJ1kPhQDBMxyL5bZSd2uwYQkIarJL1CZSerr/cv4cGz7Hy9Fkn
        sF0ClI51AJSHhvseXU7RHAilqvdBbcNa1qKoq/ftSQ==
X-Google-Smtp-Source: ACHHUZ5Xr+hSHGtB8+9YGTRMIWOuHr1JqO8SBAqGbfhonbyCk5ft2zaXWlZLGSdOnBb+LRIAccqVR8c2FN8Si/r2LPw=
X-Received: by 2002:a2e:7e0e:0:b0:2af:2626:9f1c with SMTP id
 z14-20020a2e7e0e000000b002af26269f1cmr779508ljc.11.1685455729860; Tue, 30 May
 2023 07:08:49 -0700 (PDT)
MIME-Version: 1.0
References: <20230427130539.2798797-1-amir73il@gmail.com> <CAL7ro1G7DQS_aAC4+9-ppdQz_7vjoXdBLohZ6bKo6S75NQUDPA@mail.gmail.com>
 <CAOQ4uxhN1dPBkhAu3Zag8=RKCbzMQghuXnyp+uur83dRW8tz6Q@mail.gmail.com>
 <87h6s0z6rf.fsf@redhat.com> <CAOQ4uxhkCgU2=F2oAJn34Jor2_Hr56fLsa8cAAz936G05d-+ZQ@mail.gmail.com>
 <CAL7ro1EoNDMxU2d9WYrb772VFWWMDWV=KVvrZDnK=5byemmo8Q@mail.gmail.com>
 <fb711bb4-3f25-ccee-0d21-2cb6deea75ec@linux.alibaba.com> <CAOQ4uxiCzTbr4OXhxv=RbNbKn+kaBva-Wkz4AGW8OJUwL3GfLQ@mail.gmail.com>
In-Reply-To: <CAOQ4uxiCzTbr4OXhxv=RbNbKn+kaBva-Wkz4AGW8OJUwL3GfLQ@mail.gmail.com>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Tue, 30 May 2023 16:08:38 +0200
Message-ID: <CAJfpegvsEuSNepb_9MNEkEFsW7R60DDk57x3oivA6wx9y8StRA@mail.gmail.com>
Subject: Re: [PATCH v2 00/13] Overlayfs lazy lookup of lowerdata
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Gao Xiang <hsiangkao@linux.alibaba.com>,
        Alexander Larsson <alexl@redhat.com>,
        Giuseppe Scrivano <gscrivan@redhat.com>,
        linux-unionfs@vger.kernel.org,
        Christian Brauner <brauner@kernel.org>,
        Lennart Poettering <lennart@poettering.net>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, 27 May 2023 at 16:04, Amir Goldstein <amir73il@gmail.com> wrote:

> If we would want to support data-only layers in the middle on the
> stack, which would this syntax make sense?
> lowerdir=lower1::data1:lower2::data2
>
> If this syntax makes sense to everyone, then we can change the syntax
> of data-only in the tail from lower1::data1:data2 to lower1::data1::data2
> and enforce that after the first ::, only :: are allowed.
>
> Miklos, any thoughts?
> I have a feeling that this was your natural interpretation when you first
> saw the :: syntax.

Yes, I think it's more natural to have a prefix for each data-only
layer.  And this is also good for extensibility, as discussed.

Thanks,
Miklos
