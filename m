From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/7] Overlayfs exportfs tests
Date: Thu, 11 Jan 2018 13:52:02 +0200
Message-ID: <CAOQ4uxhZ5LvJ375GF9XknTBBe9OcgYh8umiDt43Hk65QgFeUQQ@mail.gmail.com>
References: <1515348445-1403-1-git-send-email-amir73il@gmail.com> <20180111114335.GK5123@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20180111114335.GK5123@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, Miklos Szeredi <miklos@szeredi.hu>, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Jan 11, 2018 at 1:43 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Sun, Jan 07, 2018 at 08:07:18PM +0200, Amir Goldstein wrote:
>> Eryu,
>>
>> Following patches were used to test overlayfs NFS export.
>>
>> Patches 1-5 improve generic/exportfs tests, by adding test coverage
>> of some directory file handle use cases.
>
> open_by_handle test is covering more and more cases, thanks! OTOH, it's
> getting more and more complicated :)

Yeh, sorry about that ;-)

>
> But from a quick scan, I think it's time to stop adding new sub-tests to
> existing tests (maybe we should have done this since last time we added
> new sub-tests to generic/467), because generic/467 is getting more
> complex too and makes review harder.

Probably a good idea, but please note that patch 4/7 is fixing a test that was
not implemented correctly and test 5/7 adds a very minor variant.
An option is to split the directory related tests (those that are fixed by 4/7)
out of generic/467 and then fix them and add the new variant.

> Perhaps we can factor out some
> helper functions from generic/467 to common helpers and use them in new
> tests.
>

I don't think there is much to factor out, but we can add new tests
and clone the helpers. Let me know if you think differently after review.

Thanks,
Amir.
