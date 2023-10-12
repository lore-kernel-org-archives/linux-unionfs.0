Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC4ABCDB46E
	for <linux-unionfs@archiver.kernel.org>; Thu, 12 Oct 2023 08:49:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232349AbjJLItI (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 12 Oct 2023 04:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235638AbjJLItC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 12 Oct 2023 04:49:02 -0400
Received: from mail-qv1-xf34.google.com (mail-qv1-xf34.google.com [IPv6:2607:f8b0:4864:20::f34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9E3C4
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Oct 2023 01:49:01 -0700 (PDT)
Received: by mail-qv1-xf34.google.com with SMTP id 6a1803df08f44-66d060aa2a4so4397336d6.2
        for <linux-unionfs@vger.kernel.org>; Thu, 12 Oct 2023 01:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1697100540; x=1697705340; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V1bmU74T4v/JyfpTtpRIKWaNY04bVJIXqSyQPD08FoM=;
        b=YH4nIF3DPX9r/XD0jQnbpmbLkozU68QNo7zCWWWyJd7C3kBVHL6BUP/J4NLRgjuvtV
         3bjD8jE+3qFj3UWEwwJ7vWfYz3S0JZjh+h1U1aER8kq7iKgQ1slxh/litckGSwocaENm
         Tg6x48BEPNGOLZPy+TE78HP8aFsMew1PWc5zjxRM5zmo7KHEAowdSIX7EjnktFQVd+m/
         jkyXbjS/uSu/hxGfLqnJt8yG8eq1sEdF3apPvxldu14oJO7REe7z9+izN58/4pfSMPiK
         oeD/iz9gYBZTPrpCXrETFZQo1y8RxZrAFcN1lKokgXZTrGmPv1w6B8JIpRdsmr5AuTPB
         qEBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697100540; x=1697705340;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V1bmU74T4v/JyfpTtpRIKWaNY04bVJIXqSyQPD08FoM=;
        b=Y0597hRyIUDay7HIUicROEl9ibNqCOBYxvdliqqUtEKYrwL+kthTNjnM8T8AYANi9A
         n4VBTXOEKl5ziEU5Yk+oB+Ni9m1jpneRnDjbG4ToFwIa7iq7+eebEt7D9FVFcl3FnZlc
         hHgsQ2xGhC5NEW/iCGxXA2wt28R/PSQTeBPmOzac1Bocqs0kfFmL17jfVnCS0cAsvYij
         IExgBq8+jkjR1lOO3ZfwKFcKefUUhTvYw3xPxN7Po5cDoEG003rRx9gvlV0mrrul9RxQ
         yK6wbQJkHgF1NjbuV1Am9bn9eGI5Oil/B66V3Vmw82kA1jZAHPLb/6PeZ3PflEFmoZyX
         bZHg==
X-Gm-Message-State: AOJu0YwB94+TdbJ/waca/8gXFM0zg0i6ALSNdIWyRR8cGnYSPUFDnZK6
        phfpIkykc+bDFw4PiVHRp7+lvJ2QmMf6CoSBdvw=
X-Google-Smtp-Source: AGHT+IF1TOAILzJOuK6/J+YjMDuotK/slU8Nmw5qJOGDSJ0cRzBHKw1mUl/wryqbpk8SoEl9vKa0tuyFVWu2DcRF+B8=
X-Received: by 2002:a0c:f645:0:b0:65a:f332:10f9 with SMTP id
 s5-20020a0cf645000000b0065af33210f9mr25969069qvm.31.1697100540311; Thu, 12
 Oct 2023 01:49:00 -0700 (PDT)
MIME-Version: 1.0
References: <20231011164613.1766616-1-amir73il@gmail.com> <20231012-insel-prospekt-463b9baad640@brauner>
In-Reply-To: <20231012-insel-prospekt-463b9baad640@brauner>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 12 Oct 2023 11:48:49 +0300
Message-ID: <CAOQ4uxgJQ3Z4hUv_N8sSEr13rDYx8dyetiNv3uzK2fQf9GM14w@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix regression in showing lowerdir mount option
To:     Christian Brauner <brauner@kernel.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Oct 12, 2023 at 11:33=E2=80=AFAM Christian Brauner <brauner@kernel.=
org> wrote:
>
> On Wed, Oct 11, 2023 at 07:46:13PM +0300, Amir Goldstein wrote:
> > Before commit b36a5780cb44 ("ovl: modify layer parameter parsing"),
> > spaces and commas in lowerdir mount option value used to be escaped usi=
ng
> > seq_show_option().
> >
> > In current upstream, when lowerdir value has a space, it is not escaped
> > in /proc/mounts, e.g.:
> >
> >   none /mnt overlay rw,relatime,lowerdir=3Dl l,upperdir=3Du,workdir=3Dw=
 0 0
> >
> > which results in broken output of the mount utility:
> >
> >   none on /mnt type overlay (rw,relatime,lowerdir=3Dl)
> >
> > Store the original lowerdir mount options before unescaping and show
> > them using the same escaping used for seq_show_option() in addition to
> > escaping the colon separator character.
> >
> > Fixes: b36a5780cb44 ("ovl: modify layer parameter parsing")
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
>
> Seems good to me.

FYI, test pushed to
https://github.com/amir73il/xfstests/commits/overlayfs-devel

Thanks,
Amir.
