From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 00/14] Overlayfs NFS export support
Date: Thu, 9 Nov 2017 21:59:10 +0200
Message-ID: <CAOQ4uxiCx=nsSQ=XDVSOypMk9avkDn3P2YDaCoPXwFs20Qo8_g@mail.gmail.com>
References: <1508258671-10800-1-git-send-email-amir73il@gmail.com> <20171109190252.GL8773@fieldses.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f169.google.com ([209.85.161.169]:50618 "EHLO
        mail-yw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751133AbdKIT7L (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Nov 2017 14:59:11 -0500
In-Reply-To: <20171109190252.GL8773@fieldses.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: "J . Bruce Fields" <bfields@fieldses.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jeff Layton <jlayton@poochiereds.net>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Thu, Nov 9, 2017 at 9:02 PM, J . Bruce Fields <bfields@fieldses.org> wrote:
> On Tue, Oct 17, 2017 at 07:44:17PM +0300, Amir Goldstein wrote:
>> Miklos,
>>
>> This series implements NFS export support [3] and is based on
>> two prep patch sets [1][2] posted earlier to overlayfs list.
>> NFS export is enabled for overlayfs mount with the 'verify_dir'
>> and 'index=all' mount options.
>>
>> The current implementation will copy up and index directories when
>> directory file handles are encoded. Those extra copy ups could be
>> avoided in the future.
>>
>> The current implementation does NOT support encoding connectable
>> non-dir file handles for all overlay path types, so overlayfs should
>> not be exported with the 'subtree_check' option.
>> I hope this is not a show stopper for merging NFS export support?
>
> I'm not a big fan of subtree_check, and I'd be OK with filesystems
> opting out of support for it.
>
> I'm not sure what to expect when you actually try to export overlayfs
> with subtree_check.  Does it fail on the export, or when clients first
> try to access it, and what kind of error do you get?

Not an issue anymore.
I replied one day after this email that:

FYI, I implemented encoding of type OVL_FILEID_WITH_PARENT and
pushed 2 more patches to branch ovl-nfs-export-v1, so now export with
'subtree_check' should work fine.

I used a test patch (at the tip of ovl-nfs-export-v1) to encode connectable
file handles from name_to_handle_at() to unit test this code with my xfstests.

>
>> You'll notice that the series start by implementing naiive support
>> for pure upper files export and later on, replaces the implementation
>> of some of the operations. This may seem strange, but I found it
>> convenient to progress slowly between testable mile stones and I find
>> the series easier to review this way. Let me know if you want me to
>> change the way that this series is organized to get rid of code that
>> is later removed.
>>
>> To unit test overlayfs file handles, I enhanced xfstest open_by_handle
>> test utility to encode/decode directories and check several other cases
>> that were not covered by the original xfstest test. On my xfstests NFS
>> export branch [4], there are two generic tests and one overlayfs specific
>> test on the 'exportfs' group.
>>
>> I also ran the NFSTest nfstest_posix group on an exported overlayfs
>> mount, but that test only creates pure upper files in overlay upper dir,
>> so it is not much of a stress to the implementation.
>
> Might also be interesting to run some nfs tests in a loop while
> restarting the server?
>

I can try that, but I also need to create some setups with files in
lower dir and merge dirs and run tests on those, i.e. not only
files that the test creates.

BTW, the patches passed all the tests I wrote, I rebased them
on latest overlayfs-next, but still need to cleanup the series before
I post V2.

Thanks,
Amir.
