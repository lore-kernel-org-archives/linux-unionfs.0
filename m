From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH][RFC] Run unionmount testsuite with new overlay/union test group
Date: Wed, 5 Jul 2017 14:31:00 +0300
Message-ID: <CAOQ4uxiK4ovLgMcX7TN7M2S8iuNvNkAHnfy29v7gf1UkbriStQ@mail.gmail.com>
References: <1499170451-24596-1-git-send-email-amir73il@gmail.com> <20170705111049.GT23360@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36842 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750909AbdGELbB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Jul 2017 07:31:01 -0400
In-Reply-To: <20170705111049.GT23360@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>

On Wed, Jul 5, 2017 at 2:10 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Tue, Jul 04, 2017 at 03:14:11PM +0300, Amir Goldstein wrote:
>> This test group requires that unionmount-testsuite is installed
>> under src dir.
>>
>> These tests use tmpfs and have no need for test nor scratch partition.
>>
>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>> ---
>>
>> Eryu,
>>
>> unionmount-testsuite, written by David Howells, is a powerfull tool for
>> validating "union mounts", which nowadays, mostly means overlayfs.
>>
>> The testsuite was enhanced with directory rename tests for kernel v4.10,
>> and with constant inode number verification for kernel v4.12.
>> The most recent repository is maintained on my github [1].
>
> Are you planning to push all your enhancements to upstream?

I don't mind pushing 'upstream' and don't mind becoming 'upstream'
as well.
I declared my 'master' branch forward-only a while ago, when Vivek
showed interest to use it and I try to make sure that all changes that
go into master branch are backward compat with older kernels.

> Red Hat QE
> is using unionmount-testsuite to test overlayfs :) But it's downloaded
> from David's repo[1], which hasn't been updated for two years.
>
> [1] git://git.infradead.org/users/dhowells/unionmount-testsuite.git
>

Well, that repo is not so useful anymore for testing overlayfs on
kernel >= 4.10 with OVERLAYFS_REDIRECT_DIR=y
It fails some dir rename tests, which is easy to fix, but it's test
coverage for directory rename with multiple layers is insufficient.

>>
>> The tool is written in python. By default, it uses tmpfs for the
>> overlayfs layers and a complete run of all the tests in the most
>> basic configuration takes ~10 seconds on my laptop.
>>
>> I have been using xfstests as a test harness to run unionmount-testsuite
>> with several configuration (e.g. layers on same/non-same fs) and I am quite
>> certain that more people can benefit from this setup.
>>
>> The proposed patch is how I use the harness, but it raises some questions:
>> - How does xfstests community feel about relying on external repositories?
>
> I'd like to see either porting all the tests from external repositories
> to fstests or keeping them separate as they're two independent
> testsuites. I'm reluctant to make fstests rely on an external testsuite
> and make fstests a wrapper of it. I think it's easier to maintain for
> both projects, and things are simpler this way and well self-contained.
>
>> - How does xfstests community feel about including python sources in the
>>   xfstests repository?
>
> I think it's OK to include python sources if it's really needed. But we
> tend to not add more dependencies to fstests, if we have better choice,
> e.g. use perl instead. There's only one python script right now,
> tools/sort-group, but it's not used by the tests.
>

So the bottom line is that I carry this patch myself
and the many test cases that unionmount-testsuite adds for overlayfs
won't be covered by a random overlayfs developer who runs ./check -g auto.

I have no problem with this consequence myself,
I understand the complications that an external project dependency brings.
Just wanted to know if others feel differently.

Cheers,
Amir.
