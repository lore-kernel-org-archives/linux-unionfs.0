From: Amir Goldstein <amir73il@gmail.com>
Subject: unionmount-testsuite: backward compat support for REDIRECT_DIR=n
Date: Sun, 28 May 2017 17:43:45 +0300
Message-ID: <CAOQ4uxiEz0mGEQKmQav+g=kLVfq+Ct9GpZvUq7kGvZG7-7gM0A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34007 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750851AbdE1Onq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 28 May 2017 10:43:46 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, David Howells <dhowells@redhat.com>

On Tue, Apr 25, 2017 at 5:20 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Apr 25, 2017 at 4:53 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Tue, Apr 25, 2017 at 04:49:00PM +0300, Amir Goldstein wrote:
>>> On Tue, Apr 25, 2017 at 4:29 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
...
>>> >
>>> > I will enable it now. I just had an old config and ran into this.
>>> >
>>> > But this does raise the question unionmount-testsuite need to be
>>> > maintained somewhere so that it acts as a baseline to figure out if
>>> > new patches broke some existing tests.
>>> >
>>> > I can go by the tree you are maintaining but currently that's broken too
>>> > with REDIRECT_DIR=n.
>>> >
>>>
>>> Right.
>>> I have given some though about what's the best way to handle this.
>>> Probably need a test flag --noredirect. I'll add this to my TODO...
>>>
>>> BTW, I try to keep the branch overlayfs-devel uptodate for testing
>>> latest features. It could be rebased, but I'll make an effort not to.
>>> If there is a need for a more stable non-rewindable branch, let me know.
>>
>> I think would be good if you maintain "master" branch of your tree up
>> to date and hopefully that's stable so that later git pull does not talk
>> about conflicts. We can then use your tree for setting a baseline and
>> detecting regressions.
>>
>> CCing Dave Howells, in case he is interested in continuing to update his
>> tree as overlayfs kernel development takes place.
>>
>
> OK. declaring branch master on my tree 'ff-only':
> https://github.com/amir73il/unionmount-testsuite/tree/master
>

Vivek,

I added support for running my maser branch with old kernels
or with REDIRECT_DIR=n.

User needs to request backward compat mode explicitly.
When using new command line arg --xdev,
dir rename tests that would return EXDEV are skipped.

User will get a hint to use the new flag when such a test fails, e.g.:

root@kvm-xfstests:~/unionmount-testsuite# ./run --ov rename-empty-dir
***
*** ./run --ov --ts=0 rename-empty-dir
***
TEST rename-empty-dir.py:10: Rename empty dir and rename back
 ./run --rename /mnt/a/empty100 /mnt/a/no_dir100
/mnt/a/empty100: Unexpected error: Invalid cross-device link; Run
tests with --xdev to skip dir rename tests

Updated my master branch.

The new head of the master branch is commit:

  be7354d Use ./run --ov --xdev for backward compat mode

Cheers,
Amir.
