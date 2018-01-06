From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v9 00/15] overlayfs: Delayed copy up of data
Date: Sat, 6 Jan 2018 09:38:07 +0200
Message-ID: <CAOQ4uxiKAXXNOkY2gvWWkTTuw7TRu9z33az8uVf0Z47uH2LdyA@mail.gmail.com>
References: <20171129155448.32721-1-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f180.google.com ([209.85.213.180]:42050 "EHLO
        mail-yb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752213AbeAFHiJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 6 Jan 2018 02:38:09 -0500
Received: by mail-yb0-f180.google.com with SMTP id j197so1754551ybg.9
        for <linux-unionfs@vger.kernel.org>; Fri, 05 Jan 2018 23:38:08 -0800 (PST)
In-Reply-To: <20171129155448.32721-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Nov 29, 2017 at 5:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Hi,
>
> Please find attached V9 of the patches. Minor changes to take care of
> Amir's comments. I have also dropped RFC tag. If there are no concerns,
> then I would like these patches to be included.
>

Sorry Vivek, just realized some issues:

1. Considering Miklos' commit
    438c84c2f0c7 ovl: don't follow redirects if redirect_dir=off
    It is probably not a good idea to allow lookup of metacopy unless
    metacopy=on. Is that already the behavior in V9?

2. An upper layer with metacopy cannot be rotated as middle layer
    becasue non-dir origin is only followed from upper layer.
    This needs to be fixed (follow origin of metacopy from middle layer).

3. You really should write some tests to verify correctness of
    metadata before requesting to include the feature.

I recommend that you start with a simple xfstest that verify expected
behavior of a some basic use cases with
_require_scratch_feature metacopy.

Then, I suggest that you look into extending  unionmount-testsuite's
check_layer() to know about metacopy. Currently it checks that
objects that were supposed to be copied up (dentry.copied_up())
are on upper layer (dentry.on_upper()). It shouldn't be too hard to
extend that with dentry.data_copied_up() and dentry.data_on_upper().
to verify metacopy correctness.

Alas, there are currently no chmod/chown test cases in
unionmount-testsuite, so you will also need to add some test cases.

To properly test metacopy in middle layers (once it is implemented)
you can use ./run --ov=N. Currently, to verify redirect_dir,
upper layer is rotated on mkdir and rename dir. You will need
to add some relevant "rotate points" for the metacopy use cases.
For example, I added rotate and recycle points for testing
handlinks/index:
c427e85 - Cycle mount after link rename of non dir

I never got around to the TODO item
https://github.com/amir73il/overlayfs/wiki/Overlayfs-TODO#testing
"unionmount-testsuite configure rotate points"
I envisioned something like:
  ./run --ov=N rotate=mkdir,rename recycle=link
Instead of the hardcoded rotate/recycle points.

Well, you don't need to implement ALL of that ;-)

Cheers,
Amir.
