From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] overlayfs fixes for 4.9-rc3
Date: Sat, 5 Nov 2016 10:41:53 -0700
Message-ID: <CA+55aFwseoebvgSvi8sHswESOGnLknh+d6_aYAknwPFQbtp7hg@mail.gmail.com>
References: <20161104093050.GB1839@veci.piliscsaba.szeredi.hu>
 <CA+55aFx7bsMNKMfxaxXuw=E13H5dQpGQHdNgBKKt_JKyL2eGeQ@mail.gmail.com> <CAOQ4uxjsfAwpvKj1PXvR+_DWKm0HxF7sn1j7QfTzXWquvvXvTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:35177 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752918AbcKERlz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 5 Nov 2016 13:41:55 -0400
In-Reply-To: <CAOQ4uxjsfAwpvKj1PXvR+_DWKm0HxF7sn1j7QfTzXWquvvXvTQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org

On Fri, Nov 4, 2016 at 11:44 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>
> Can you please clarify your objection?

There are several:

 - timing. No way in hell will I take a new feature like this during an rc

 - lack of explanation. Why is this bad feature needed in the first
place? Why would overlayfs versioning _ever_ be a good idea?

 - is the implementation even sane? Right now I don't think overlayfs
even requires xattr support in the upper filesystem, so the whole
concept seems frankly totally misdesigned.

> I suppose you do not object to the concept of on-disk format version nor on-disk
> format compatible/incompatible features sets.

I object both to the concept and to the implementation and to the
timing. The thing seems broken. Doing it during the rc cycle makes it
doubly so.

> Just to fact that overlayfs didn't have those form day one, so it
> should find a way to cope with that situation without patching
> stable kernels?

What "situation"? There's no f*cking explanation of why we'd even want
this crap. Not in the commit message, not in the pull request, not
*anywhere*.

And then the commit marks that shit for stable? When it clearly
doesn't fix anything, and it has never ever been needed before?

NO.

               Linus
