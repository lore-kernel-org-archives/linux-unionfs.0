From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] long mount option support
Date: Tue, 24 Oct 2017 11:43:17 +0200
Message-ID: <CAJfpeguPKtGMZ_YYyBqDc=WOvwK6fSiFMJW4NdESR5X+w3tLoA@mail.gmail.com>
References: <D90A2B0B-C311-4F73-9CB7-D6361EDCD131@mykernel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:48830 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751791AbdJXJnT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 24 Oct 2017 05:43:19 -0400
Received: by mail-wm0-f68.google.com with SMTP id p75so14456826wmg.3
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Oct 2017 02:43:19 -0700 (PDT)
In-Reply-To: <D90A2B0B-C311-4F73-9CB7-D6361EDCD131@mykernel.net>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: cgxu <cgxu@mykernel.net>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, David Howells <dhowells@redhat.com>

On Tue, Oct 24, 2017 at 5:44 AM, cgxu <cgxu@mykernel.net> wrote:
> Hi Miklos,
>
> We=E2=80=99re testing our container system using overlayfs as image stora=
ge.
> We noticed that although overlayfs supports maximum 500 layers in filesys=
tem,
> but  when lowerdir is quite long then mount will fail because of mount op=
tion=E2=80=99s one PAGE SIZE limitation.
> In our environment, we added new mount option =E2=80=9Clong_option=E2=80=
=9D to deliver long mount option with extended attribute.
> This approach is backward compatible and could be useful to container.
> I have done basic testing on this and hope to hear some feedback for the =
patch.
>
> Detail explanations:
> In this approach, we can set mount option both in command line and config=
 file=E2=80=99s extended attribute.
> There are three possible cases as below.

Patchset from David Howells (*) will allow unlimited mount options.
I'd rather wait for that than adding hacks to work around the page
size limitation.

Thanks,
Miklos

(*) https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg1506283.ht=
ml
