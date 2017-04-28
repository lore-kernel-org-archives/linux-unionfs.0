From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/5] fstests: more tests for overlay constant inode numbers
Date: Fri, 28 Apr 2017 08:39:33 +0300
Message-ID: <CAOQ4uxiQ_OhXGM9scSsACHCuNxN_hqAy3tuv2+ry11cuE-Schg@mail.gmail.com>
References: <1493305775-12559-1-git-send-email-amir73il@gmail.com> <20170428053020.GK26397@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <fstests-owner@vger.kernel.org>
In-Reply-To: <20170428053020.GK26397@eguan.usersys.redhat.com>
Sender: fstests-owner@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Apr 28, 2017 at 8:30 AM, Eryu Guan <eguan@redhat.com> wrote:
> On Thu, Apr 27, 2017 at 06:09:30PM +0300, Amir Goldstein wrote:
>> Hi Eryu,
>>
>> This series contains enhancements to overlay/017, which I used to test
>> my work on overlayfs constant inode numbers. [1]
>>
>> The original test was a bit naiive, not taking into account renames,
>> drop caches and mount cycle. All those are added by this series.
>
> Thanks for the tests! Though usually we don't add new tests to existing
> test cases, given that overlay/017 never passed before and won't pass
> after adding these tests too, I think it's fine to merge this patchset,
> as overlay/017 won't cause any false regression in tests.
>

That was my thinking as well...
016-018 were born to track the 'Non-standard behavior' cases from
Documentation/filesystems/overlayfs.txt in the expectation that those
will be fixed at some point.
017 was just not doing a good enough job to cover the 'non constant ino'
behavior.

I have seen some people already wanted to test my patch set, so better
have 017 prepared for them instead of having to pull it from my branch.

Heads up - I also have some patches to enhance overlay/018, but
I intend to add some more before I send out a batch.

I may also add more beef to 017 related to constant st_dev/st_ino
and not just st_ino. Since 017 is still failing, I figure that would be ok.

Amir.
