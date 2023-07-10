Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9EDBCEB64DA
	for <linux-unionfs@archiver.kernel.org>; Mon, 10 Jul 2023 08:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjGJIs7 (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 10 Jul 2023 04:48:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbjGJIs4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 10 Jul 2023 04:48:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BA52C3
        for <linux-unionfs@vger.kernel.org>; Mon, 10 Jul 2023 01:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688978890;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lt5H+Faozf8MXSEoVXeb0fBDhrXePOF/bQO4FQT+bnU=;
        b=hM5449+dNdyE3NVs5b75yFeMuYaqeF4XvdS0/U0Q2qVHwwpKswaDh2jeNPV7EkJvmY3n8j
        0CywLocRh6/j/tOdwHTgvVIo8XNmP02mOT5f6BsIGWlCqwZbOY+YwwQkPbmdB5g9CTm6vc
        4pZ0YCevIrb/ES4KjeSCyM+EKuhjsnY=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-673-UdtA1VeZOASE28ousoz7gA-1; Mon, 10 Jul 2023 04:48:09 -0400
X-MC-Unique: UdtA1VeZOASE28ousoz7gA-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3463fbf2ffeso25790875ab.2
        for <linux-unionfs@vger.kernel.org>; Mon, 10 Jul 2023 01:48:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688978888; x=1691570888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lt5H+Faozf8MXSEoVXeb0fBDhrXePOF/bQO4FQT+bnU=;
        b=YkMo5fGJAkqItfYahGQMwNVc8B04FvNBfAjLx8uYoHfIgjl4GZ1N7mFR9Vqf0nIC56
         am8LK19/yBhhVa7Uztiy0/2ejeeLBc1hKH+gYUFhgMn4Sl1UdT9FVEbFe7faoKPFXmDc
         6yLszT1HZJwLr/W+F//D5DUXiLwwMyPWlzaLTKVfbj4yp9wOHJ6yejLz3Fco4Z4apW5Y
         Ru3ZP5fWrhkeJBwUbmnY5i9MyZdsBBC4su8bUCDTfqnQFAlksj8zoY/c1P7LnDvWUdgV
         zstsfW7mhzeGewK1kFhLLgPVQfynF+hXguzjkmm189DiQ8Jf5WLOrq5RQNV3XWs9pwee
         emwA==
X-Gm-Message-State: ABy/qLanNZRRl/vvB4IajN6rFHtMXcKh0sHgtPTTOhs6sOz69bgFBWBU
        vP4bV8vVhKYDk7SEmbOVeybKF3SHj1CZM9zNrFfsXNyB+Dd0jcsAzOjKeMlHYV6rLs7NC1WUDF8
        U3T09OL6nuNYFtBzVt7z/Ezn5knE7Wh3qysPj+sjNmA==
X-Received: by 2002:a92:cb45:0:b0:346:240f:71f7 with SMTP id f5-20020a92cb45000000b00346240f71f7mr12541764ilq.2.1688978888675;
        Mon, 10 Jul 2023 01:48:08 -0700 (PDT)
X-Google-Smtp-Source: APBJJlFvREq/9utOB6GWyGMk2WxrtEr/U+d2K7VQ1uUCAajT3Fw81SfHfVX4GDc9TYyeyR5yrnxf9bHxjbPo3EKlWp0=
X-Received: by 2002:a92:cb45:0:b0:346:240f:71f7 with SMTP id
 f5-20020a92cb45000000b00346240f71f7mr12541752ilq.2.1688978888480; Mon, 10 Jul
 2023 01:48:08 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1688634271.git.alexl@redhat.com> <0d9e64f67dfe314f163a5c8c15421a48deb9a9d5.1688634271.git.alexl@redhat.com>
 <20230708015619.GA1731@sol.localdomain>
In-Reply-To: <20230708015619.GA1731@sol.localdomain>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Mon, 10 Jul 2023 10:47:57 +0200
Message-ID: <CAL7ro1GuZ3_pLyGSUWcr0W9PCq6SEP3GuiM59iW=1tVwbahP-A@mail.gmail.com>
Subject: Re: [PATCH 4/4] overlay: Add test coverage for fs-verity support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sat, Jul 8, 2023 at 3:56=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> w=
rote:
>
> On Thu, Jul 06, 2023 at 11:51:01AM +0200, alexl@redhat.com wrote:
> > +     local fstyp=3D${1:-$FSTYP}
> > +     local scratch_mnt=3D${2:-$SCRATCH_MNT}
>
> Some code after this still uses $FSTYP and $SCRATCH_MNT.  Is that a bug?

Yes. Will fix.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

