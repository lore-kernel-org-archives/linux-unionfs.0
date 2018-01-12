From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/7] Overlayfs exportfs tests
Date: Fri, 12 Jan 2018 15:07:47 +0200
Message-ID: <CAOQ4uxjTdFbUGk3MpKjaydZ1bOEQUnjqHCT-Qbas5BHRFyVPzw@mail.gmail.com>
References: <1515348445-1403-1-git-send-email-amir73il@gmail.com>
 <20180111114335.GK5123@eguan.usersys.redhat.com> <CAOQ4uxhZ5LvJ375GF9XknTBBe9OcgYh8umiDt43Hk65QgFeUQQ@mail.gmail.com>
 <20180112115227.GR5123@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f196.google.com ([209.85.213.196]:40642 "EHLO
        mail-yb0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932797AbeALNHt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 12 Jan 2018 08:07:49 -0500
In-Reply-To: <20180112115227.GR5123@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>

On Fri, Jan 12, 2018 at 1:52 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Thu, Jan 11, 2018 at 01:52:02PM +0200, Amir Goldstein wrote:
>> On Thu, Jan 11, 2018 at 1:43 PM, Eryu Guan <eguan@redhat.com> wrote:
>> > On Sun, Jan 07, 2018 at 08:07:18PM +0200, Amir Goldstein wrote:
>> >> Eryu,
>> >>
>> >> Following patches were used to test overlayfs NFS export.
>> >>
>> >> Patches 1-5 improve generic/exportfs tests, by adding test coverage
>> >> of some directory file handle use cases.
>> >
>> > open_by_handle test is covering more and more cases, thanks! OTOH, it's
>> > getting more and more complicated :)
>>
>> Yeh, sorry about that ;-)
>>
>> >
>> > But from a quick scan, I think it's time to stop adding new sub-tests to
>> > existing tests (maybe we should have done this since last time we added
>> > new sub-tests to generic/467), because generic/467 is getting more
>> > complex too and makes review harder.
>>
>> Probably a good idea, but please note that patch 4/7 is fixing a test that was
>> not implemented correctly and test 5/7 adds a very minor variant.
>
> I've gone through the first 5 patches now. All look fine except the
> comments to patch 1/7.
>
> I think we can add a new test that contains the last part of patch 4/7
> ("Check non-stale file handles of renamed dirs") and patch 5/7. And
> leave the "fix test" part in patch 4/7.
>
>> An option is to split the directory related tests (those that are fixed by 4/7)
>> out of generic/467 and then fix them and add the new variant.
>
> This should be fine too, but I slightly tend to not move existing tests,
> just add new cases to new tests.
>

So what I think I will do is not change generic/467, but add a variant of
generic/467 that tests open_by_handle after mount cycle that will use -i -o.
I will try re-work patch 1/7 and maybe add more changes so open_by_handle
becomes more of a tool to write file handle tests instead of a file handle
test program that does all tests and just invoked from a tests script.
If that doesn't work out, I'll just add more commentary to the patch ;-)

Thanks,
Amir.
