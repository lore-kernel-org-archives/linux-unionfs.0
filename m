Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180511104156.GO8373@desktop>
References: <20180509152705.GA10101@redhat.com> <CAOQ4uxgRb0T6nWou7uasOF+QGEHRMa1C5wD4AsJABJDXK+yNhQ@mail.gmail.com>
 <20180511104156.GO8373@desktop>
From: Amir Goldstein <amir73il@gmail.com>
Date: Tue, 29 May 2018 20:08:03 +0300
Message-ID: <CAOQ4uxhDGKVdhqW_PU0RFzcysHO4XCeEHy0iHz-kgFUja-2nLA@mail.gmail.com>
Subject: Re: [PATCH V2] xfstest: overlay: Add tests for overlay metadata only
 copy up feature
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <guaneryu@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, May 11, 2018 at 1:41 PM, Eryu Guan <guaneryu@gmail.com> wrote:
> On Wed, May 09, 2018 at 07:22:48PM +0300, Amir Goldstein wrote:
>> On Wed, May 9, 2018 at 6:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > Hi,
>> >
>> > Please find attached the V2 of the patch. Took care of Amir's comments
>> > from previous version.
>> >
>> > Add tests for metadata only copy up feature.
>> >
>> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
>>
>> Looks good.
>>
>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>
> Thanks for the review!
>
>>
>> Just a note to Eryu -
>>
>> You may want to hold on to this test until metacopy is merged
>> or at least staged on Miklos' next branch.
>
> I'd wait for the patches hit Miklos' tree.
>

Vivek,

This test seems to fail with overlayfs-next on check_file_blocks().
With ext4 underneath, blocks count is bigger than expected by 8 sectors.
With xfs+reflink the blocks check also fails with different actual nr of blocks.

I think it is generally unreliable to try to compute nr of blocks
and fail the test if actual is different than computed.
Maybe just check that overlay nr blocks is as the actual lower nr of
blocks.

Thanks,
Amir.
