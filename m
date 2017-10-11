From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 3/9] ovl: Provide a mount option metacopy=on/off for
 metadata copyup
Date: Wed, 11 Oct 2017 20:36:03 +0300
Message-ID: <CAOQ4uxiano2-_YBOgND9O+D3B8bbHK1fUvUwQWev9HGmCkFmjQ@mail.gmail.com>
References: <1507649544-4539-1-git-send-email-vgoyal@redhat.com>
 <1507649544-4539-4-git-send-email-vgoyal@redhat.com> <CAOQ4uxiU6BNrwKnfx1ToY4ZARV8X4S6HRNmfhCmaON=+46B7bg@mail.gmail.com>
 <20171011135715.GB8086@redhat.com> <CAOQ4uxg1OwbFuytiHLn3fwXzu3mZ8cwW6Vadj3YgTihbiL0BdA@mail.gmail.com>
 <20171011165348.GC8086@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:35306 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752173AbdJKRgE (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 11 Oct 2017 13:36:04 -0400
Received: by mail-qt0-f196.google.com with SMTP id z19so583680qtg.2
        for <linux-unionfs@vger.kernel.org>; Wed, 11 Oct 2017 10:36:04 -0700 (PDT)
In-Reply-To: <20171011165348.GC8086@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, "Eric W. Biederman" <ebiederm@xmission.com>

On Wed, Oct 11, 2017 at 7:53 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Oct 11, 2017 at 07:29:38PM +0300, Amir Goldstein wrote:
>
> [..]
>> >
>> > Anyway, I did not understand what's the problem with borken upper
>> > hardlinks when index=off. If two upper hardlinks (broken), can
>> > point to same ORIGIN on lower, they will just copy up same data.
>> >
>> > IOW, it does not seem to be more broken then what it is now just
>> > becase of metadata copy up or because of both upper pointing to
>> > same ORIGIN? What am I missing.
>> >
>> It is not broken now because we intentionally do NOT set origin when
>> copying up lower hardlinks and index is disabled.
>> You must not break this rule, so instead you can avoid metacopy for
>> lower hardlinks when index is disabled.
>
> Hi Amir,
>
> Ok, I am open to change it so that if index=off, lower hardlinks are not
> copied up metadata only.
>
> But please help me understand that what *additional* thing breaks if origin
> is set when index=off.
>
> Say lower has a file foo.txt and another hard link foo-link.txt.
> (say index=off, metacopy=off).
>
> Say, I open foo-link.txt for WRITE, and it gets copied up. Now there is
> no link between foo-link.txt and foo.txt and if a user opens foo.txt for
> READ, it does not see updates to foo-link.txt. So this is the broken
> behavior of hardlinks with index=off, as of today.
>
> Now I go back to original state and this time do same operation with
> (indxex=off, metacopy=on). Then "chown foo-link.txt" will only copy
> metadata and set origin to lower file. Say I also chown "foo.txt", that
> will do the same thing. Now both foo.txt and foo-link.txt will have
> ORIGIN pointing to same lower inode. If any of the file is opened for
> WRITE, data will be copied up from same origin.
>
> So setting same ORIGIN on two upper files, does not seem to break anything
> additional, AFAICS. What am I missing.
>

Sorry for brevity of my response earlier. I was hopping on a plane.
The problem is a bit convoluted to explain, but here goes.

ORIGIN was introduced to implement constant st_ino across copy up.
stat(2) of an overlay file with ORIGIN (both layer in same fs) returns
st_ino of origin inode.

When copy up breaks lower hardlink to *different* upper inodes,
then those broken aliases MUST NOT return the same st_ino,
because they are different files with different data.

Only when index is enabled and copy up does not break lower
hardlink, it is legal to set ORIGIN for every upper alias, because
all upper aliases can and should return same st_ino (the origin st_ino)
from stat(2).

So that is the simplest way to explain why you MUST NOT set ORIGIN
on copy up of lower hardlink when index is disabled and therefore, you
cannot use ORIGIN for metacopy.

As I wrote in some email, you could set METAORIGIN xattr in this case
just for the use of metacopy, but I rather not have this special case.

Beyond the problem stated above with st_ino of broken hardlinks,
if broken hardlinks have the same ORIGIN, this also breaks indexing
assumptions and can lead to EIO on lookup, but no need to get into that.

Hope this is clear now,
Cheers,
Amir.
