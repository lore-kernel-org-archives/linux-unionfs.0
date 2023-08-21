Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C1F7EE49A6
	for <linux-unionfs@archiver.kernel.org>; Mon, 21 Aug 2023 20:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230348AbjHUUIr (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 21 Aug 2023 16:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230345AbjHUUIr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Aug 2023 16:08:47 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA2AF11C
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Aug 2023 13:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692648475;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N9m7RzuN2iUpzmNPgco2wdF0bYNDkv+yBWghv69m/p4=;
        b=BjezLj4JWHayjg8AJgO0dvoKQJ8kdL0sUlO3UbqQ/+GEQCy2VPiwsyOiLMtQMg8cg14+lT
        3SU4tvV/ZFUpDvvdWE9izCNu0s+RBev0RDFlqc2PFAhvirDD9oELoIGeWaHWak6bGInIWY
        2mIyckST8fpn1mXMuZfOFnP9gNRtwYg=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-473-115Z78N0MFCiVYwzVDaRPA-1; Mon, 21 Aug 2023 16:07:54 -0400
X-MC-Unique: 115Z78N0MFCiVYwzVDaRPA-1
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-34bb6ac8bf7so36709035ab.2
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Aug 2023 13:07:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692648473; x=1693253273;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N9m7RzuN2iUpzmNPgco2wdF0bYNDkv+yBWghv69m/p4=;
        b=ME59BWEilqjB0hASoE4bqTCYQBdbeJzJZ8VZq6846J/m3ZTfI37gmRMIbkLAmheRCT
         zo8QKOcvYtjcAJyTkeTOXYdyFP3m2CaDq66yRYsbwIdpv+8P4Yq1aJmOpmZkoIEij76D
         FFWd3jKvYLufHZhfq2q2a5EaifnvcCS4MDyID8fG7YMkOP9nxncANrQsXV/vPDm/ATCc
         YL5WTJYqSl7EQV69H4XASQd3jhVROn7tt7WgbH7o1NhW057lAGdxZKCI7sxA52oRmcOv
         ASPo1bU4U5H1S5pZ/dTFavi1R/wgWiuM1wJiE8pmDMiWuC9+T0R84jQrVFad9Sf+EYnj
         7zWQ==
X-Gm-Message-State: AOJu0YzUIVdgOLla+0GaERLMsftUGboo7UUkFOrlnmwfWp0hxrrUiug9
        e4/tzCbsqlaGqiErActUPtCeXha861tvLS1mcQ1jz2iNolIRFIgjBhacXyjTclrRRM1caoQlcZK
        KvTc7qKKqwr1o00bU3l/OBWCCA1sVH9/Vh0fYhUnulA==
X-Received: by 2002:a05:6e02:1241:b0:349:2bb0:c87d with SMTP id j1-20020a056e02124100b003492bb0c87dmr7469501ilq.32.1692648473650;
        Mon, 21 Aug 2023 13:07:53 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFw5HFj10ldPuNOkSzwUqXs6o44WcSaCg4k9YNVdsMePdgnHmYYuI5xW1QdX+zKkTlpuSY3h52eJcKE/mwVzw=
X-Received: by 2002:a05:6e02:1241:b0:349:2bb0:c87d with SMTP id
 j1-20020a056e02124100b003492bb0c87dmr7469494ilq.32.1692648473461; Mon, 21 Aug
 2023 13:07:53 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <f140fd46c2f61e69630c14a6b3fb8ed5e3c62307.1692270188.git.alexl@redhat.com>
 <CAJfpeguHCVFpcGVWdP5-j+7-+4cqjvd+-40UM=+vL1OFwS7rZA@mail.gmail.com>
 <CAL7ro1G1uDUhOS0yJdaSKAz-8BkxS++gd29=K7Jr27zZU1wbPQ@mail.gmail.com>
 <CAOQ4uxgAvkrEo=ZOiaY=+HGzVMsk4UCA+D5RfYdEj2Ubffh27Q@mail.gmail.com>
 <CAL7ro1HskLvD6z5m_yyj6bJvzUdFk=D3jSkfeaKjgBtxCFP+Sw@mail.gmail.com> <CAJfpegs1QFfcRQ717qzNPnSjz3BfMVy-cOOWSM8=5PUjoFG_Vw@mail.gmail.com>
In-Reply-To: <CAJfpegs1QFfcRQ717qzNPnSjz3BfMVy-cOOWSM8=5PUjoFG_Vw@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Mon, 21 Aug 2023 22:07:42 +0200
Message-ID: <CAL7ro1FO1AvpsoSO-fLkH0gRt1UU0NYPmjqKeFAHk0owz+E_jg@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] ovl: Support creation of whiteout files on overlayfs
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Mon, Aug 21, 2023 at 5:48=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Mon, 21 Aug 2023 at 17:31, Alexander Larsson <alexl@redhat.com> wrote:
>
> > So, I guess the end result is that it's probably ok to use an extra
> > getxattr here, and that fuse should probably grow an xattr cache.
>
> Having an xattr cache in the page cache would be wonderful, but it's
> not how normal filesystems work and I have no idea how to get there.
> I should probably talk to Matthew.

The bloom filter stuff that erofs is adding for this is cool. You
could do something like that generically to at least catch negative
xattr lookups. From a single listxattrs you could build such a 32bit
in-memory bloom filter for later xattr lookups. And a fuse daemon
could pre-seed the filter for an inode to avoid roundtrips.

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

