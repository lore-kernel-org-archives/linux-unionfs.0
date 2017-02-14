From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 0/9] fstests: new way to run overlay tests
Date: Tue, 14 Feb 2017 11:51:35 +0200
Message-ID: <CAOQ4uxh5c0WkNL8Q1GRpQBFXQmH-n2OASbw=xi5SOicSjTrprQ@mail.gmail.com>
References: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
 <20170213041924.r5nho3xdkydzff6k@XZHOUW.usersys.redhat.com>
 <CAOQ4uxihrEX5M0EYB-9ni90GPb3em1AbowFY+BvPZ3jtoigq4g@mail.gmail.com>
 <20170214044028.y45ai2dwzm7qx3k5@XZHOUW.usersys.redhat.com>
 <CAOQ4uxgjNe86U5FZ-MZCrSve7M47iMsJDax6FYBkyO4+JK-iig@mail.gmail.com> <20170214092511.3b4i3c5i36o446lr@XZHOUW.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34115 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753460AbdBNJvg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Feb 2017 04:51:36 -0500
In-Reply-To: <20170214092511.3b4i3c5i36o446lr@XZHOUW.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Xiong Zhou <xzhou@redhat.com>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Tue, Feb 14, 2017 at 11:25 AM, Xiong Zhou <xzhou@redhat.com> wrote:
> On Tue, Feb 14, 2017 at 08:15:22AM +0200, Amir Goldstein wrote:
>> On Tue, Feb 14, 2017 at 6:40 AM, Xiong Zhou <xzhou@redhat.com> wrote:
>> > On Mon, Feb 13, 2017 at 07:37:45AM +0200, Amir Goldstein wrote:
>> >> On Mon, Feb 13, 2017 at 6:19 AM, Xiong Zhou <xzhou@redhat.com> wrote:
>> >> > On Sun, Feb 12, 2017 at 10:43:35PM +0200, Amir Goldstein wrote:
>> >> >> Hi Eryu and all,
>> >> >>
>> >> >> The reason I started this work was to help catch overlayfs bugs
>> >> >> related to leaking objects in underlying (base) fs.
>> >> >
>> >> > So firstly, what's wrong with the existing way exactly ?
>> >> >
>> >>
>> >> One of the reasons that xfstests cycle mounts scratch partition
>> >> is that some bugs, such as object leaking bugs, are only discovered
>> >> when trying to unmount the file system.
>> >>
>> >> With overlayfs tests the cycling of overlay mount can detect bugs
>> >> related to overlayfs objects leaking, but not to base fs objects leaking.
>> >> OTOH, some bugs may be triggered in base fs when used under
>> >> overlayfs, but not when tests are run directly over the fs.
>> >>
>> >> The solution is to cycle mount both overlay mount and the base fs
>> >> underneath it to detect all those bugs.
>> >
>> > Good job.
>> >
>> >>
>> >> I started off (in V1) with a more complex way to manually configure
>> >> OVL_BASE_TEST_DEV, OVL_BASE_TEST_DIR, etc, but that
>> >> became very cumbersome.
>> >>
>> >> Eryu pointed out the over complication of this configuration, so
>> >> I decided to re-think the "old way", which I always thought was
>> >> a bit hackish.
>> >>
>> >> The "new way" enables running overlay tests over a range of
>> >> base fs configurations, which was not possible before without
>> >> using external scripts to wrap xfstests.
>> >>
>> >> But above all, the "new way" represents a different perspective
>> >> of overlayfs testing - testing overlayfs independently of the
>> >> underlying fs is doing half the job.
>> >>
>> >> You may say that overlayfs is closer to "MOUNT_OPTIONS"
>> >> then it is to "FSTYP". The truth is somewhere in the middle,
>> >> but the fact is that running a single "overlay" test does not cut it.
>> >> To tests overlay thoroughly, one would need to test overlay over
>> >> xfs, ext4, btrfs and to test xfs thoroughly, one would need to test
>> >> xfs, xfs+reflink, xfs+overlay, xfs+reflink+overlay, etc.
>> >>
>> >> The new way provides an easy way to configure those tests,
>> >> using semantics that people are used to when testing multiple
>> >> flavors of configurations.
>> >
>> > I'd like more comments or document for these NEW configurations, other
>> > than one or two lines in Examples.
>> >
>> > In other words, what kind of configuration your patches bringing
>> > support to ?
>> >
>>
>> There are 2 parts for this answer:
>>
>> 1. Single section config file
>> ====================
>>
>> The answer here is there is no new configuration.
>> All you need to do is forget everything you knew about old overlay test config.
>
> That's okay, i just need to know what I am testing for. With a
> "new way" to run tests, how I can control my test configuration
> with the config file, what every line in the config file means
> to the "new way".
>

All the lines in config mean exactly what they meant before
and they all refer to the configuration on the base fs partitions.
There are some vars that are ignored for -overlay run, like MKFS_OPTIONS
I can document that, but this is implied from
"The TEST and SCRATCH partitions should be pre-formatted"

>>
>> Take an existing test configuration you have and already use:
>>      TEST_DEV=/dev/sda5
>>      TEST_DIR=/mnt/test
>>      SCRATCH_DEV=/dev/sda6
>>      SCRATCH_MNT=/mnt/scratch
>>      FSTYP=xfs
>>
>> and just run './check -overlay' whenever you want to test overlayfs
>> and './check' whenever you want to test native fs.
>>
>> I could add more and more examples to README, but it's not like
>> README tells you much about how to use other configurations.
>
> Agree. It's fair enough to keep this "how the new way interprets
> old config file" in commit message. Ya.. finally i found that..

"old way" was never documented and Eryu want to deprecate it
so I see no reason to document how old configuration is supported
it suffice to say that current change should not break existing
config files of  users that test overlay

>
> Still I think you can add more config examples in commit message
> or somewhere, for your saying:
>> >> To tests overlay thoroughly, one would need to test overlay over
>> >> xfs, ext4, btrfs and to test xfs thoroughly, one would need to test
>> >> xfs, xfs+reflink, xfs+overlay, xfs+reflink+overlay, etc.
>> >>
>> >> The new way provides an easy way to configure those tests,
>> >> using semantics that people are used to when testing multiple
>> >> flavors of configurations.
>
> Then people can test your code with your examples. Ya, i'am lazy :)
>
> I guess -overlay option consider FSTYP as fs type for base fs.
> While with above config file FSTYP=xfs,
> if /dev/sda{5,6} are formated as ext4 fs before running,
> ./check -overlay generic/001 will test with base fs as ext4,
> (I don't get what i config for)
> ./check generic/001 will stop test "wrong fs type".
>
> Yes, it's human error. It's great if -overlay option can also stop
> test as general, to correct this error.
>

I now regret getting into the multi section example.
I will withdraw any support for this scenario.

> Thanks for you time and Sorry for my bad questions.
>

Not at all. Serves me right for publishing instructions to a half baked feature.

Thanks for keeping me honest!

Amir.
