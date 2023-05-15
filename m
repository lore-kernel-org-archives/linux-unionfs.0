Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC745C77B7D
	for <linux-unionfs@archiver.kernel.org>; Mon, 15 May 2023 05:45:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238231AbjEOFpa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Mon, 15 May 2023 01:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238422AbjEOFpN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 May 2023 01:45:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD011FCA
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 22:44:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684129466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=mlBIloOQ8YgdNf3WmrKfOUSAHAHodv7xQqACQloMrYg=;
        b=bdlEovqMwZZXYxAydCTP+8ab7h4kvIYvm8zTA2thBjxQmCBw8yMFuQ9ioRn5gWHeLFZMtb
        EP+0CxUFmodqJPoJc+VMFL9GDUpYVz+riNsdC3KUAymN4GxjDgA5I4XiY1L9SQ7h91oGLN
        4hpEx9nR7nQSgM/VNUwlX6NYW/ZJCkc=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-578-dRLZUJMrOpSLdQzn83mqKg-1; Mon, 15 May 2023 01:44:25 -0400
X-MC-Unique: dRLZUJMrOpSLdQzn83mqKg-1
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-331949eb356so78936265ab.0
        for <linux-unionfs@vger.kernel.org>; Sun, 14 May 2023 22:44:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684129464; x=1686721464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mlBIloOQ8YgdNf3WmrKfOUSAHAHodv7xQqACQloMrYg=;
        b=jamHNdyTiboQKR2wV3areI1ezjn5TPhyoL+poKhwGk1F2eDhPadhcSKHIPzkQAkeAr
         18QIRMjAvx7jF7HIFLsRdAuasZQ76UNO8KfHUzo9Qg1QR7UoN5yBZjmE9Ga5NQPpPdpj
         kLR1uclrJ9CH+e/ARSUEK7xhb+LzZ9NpNw2vmo9I/LM/shnbTuRQmMc5/D5MjDxNaxq6
         A3+YsEb7Kz70CVHTz8I6RqTVShe8JAZRXclzaJGT89kbLDXGUURYYz8ODJAruwcH8q9S
         0j93vVurQ77zEuPuhCrrrNmY/3n5G0ghg8ZP8EDRb0Ekks/VR3zlTclRdqF3fox78Hyu
         9VUQ==
X-Gm-Message-State: AC+VfDzXVcJGn9xe1x9zZ0EBbd9OMraNeJh8D88KzH3WjRWu2koxh5C2
        8QnlWQV+MyTS63cDiKCYysL596zecSBEKQmJjqEX8GDBG1M7EDt2giT+GOqtfgIy6Dm1hasyKyj
        /Kbs43dhRwkeqo/8CQce5epRl0YGqgTU7CeGhubgHQw==
X-Received: by 2002:a92:d6ca:0:b0:331:284:eaf8 with SMTP id z10-20020a92d6ca000000b003310284eaf8mr20845296ilp.21.1684129464531;
        Sun, 14 May 2023 22:44:24 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ7qrWNNh2bJrj/TfUIDttBvVzho7/JC7ep8S1iBngpobIZ4pMlAUgAtN2uZbn3oFByN08rB/4PHQrZIUiVTpNY=
X-Received: by 2002:a92:d6ca:0:b0:331:284:eaf8 with SMTP id
 z10-20020a92d6ca000000b003310284eaf8mr20845290ilp.21.1684129464322; Sun, 14
 May 2023 22:44:24 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1683102959.git.alexl@redhat.com> <0292ade77250a8bb563744f596ecaab5614cbd80.1683102959.git.alexl@redhat.com>
 <20230514192227.GE9528@sol.localdomain>
In-Reply-To: <20230514192227.GE9528@sol.localdomain>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Mon, 15 May 2023 07:44:13 +0200
Message-ID: <CAL7ro1EaqFcS5sRAAJLWuiy4OHEP8KGXTm5T-LRh09XSrnav5A@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] ovl: Add framework for verity support
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        amir73il@gmail.com, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, May 14, 2023 at 9:22=E2=80=AFPM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> On Wed, May 03, 2023 at 10:51:37AM +0200, Alexander Larsson wrote:
> > +- "require":
> > +    Same as "on", but additionally all metacopy files must specify a
> > +    verity xattr. This means metadata copy up will only be used if
> > +    the data file has fs-verity enabled, otherwise a full copy-up is
> > +    used.
>
> The second sentence makes it sound like an attacker can inject arbitrary =
data
> just by replacing a data file with one that doesn't have fsverity enabled=
.
>
> I really hope that's not the case?
>
> I *think* there is a subtlety here involving "metacopy files" that were c=
reated
> ahead of time by the user, vs. being generated by overlayfs.  But it's no=
t
> really explained.

I'm not sure what you mean here? When you say "replacing a data file",
do you mean "changing the content of the lowerdir"? Because if you can
just change lowerdir content then you can make users of the overlayfs
mount read whatever data you want (independent of metacopy or any of
this).

The second sentence above relates to this case:

* A lower dir file "lower/a" does not have fsverity enabled.
* Someone does "chown mnt/a"
* This causes overlayfs to make a "copy up" operation of the "lower/a"
to "upper/a"
* But, we can't use the optimized "copy metacopy only" version of
"copy up", because we could then not specify a digest xattr on the new
file, so we copy the content of "lower/a" to "upper/a".

What exactly is your worry in this case?

--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

