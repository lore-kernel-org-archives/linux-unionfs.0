Return-Path: <vgoyal@redhat.com>
Date: Tue, 29 May 2018 15:11:33 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH V2] xfstest: overlay: Add tests for overlay metadata only
 copy up feature
Message-ID: <20180529191133.GA13363@redhat.com>
References: <20180509152705.GA10101@redhat.com>
 <CAOQ4uxgRb0T6nWou7uasOF+QGEHRMa1C5wD4AsJABJDXK+yNhQ@mail.gmail.com>
 <20180511104156.GO8373@desktop>
 <CAOQ4uxhDGKVdhqW_PU0RFzcysHO4XCeEHy0iHz-kgFUja-2nLA@mail.gmail.com>
 <20180529185241.GB3774@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180529185241.GB3774@redhat.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Eryu Guan <guaneryu@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, May 29, 2018 at 02:52:41PM -0400, Vivek Goyal wrote:
> On Tue, May 29, 2018 at 08:08:03PM +0300, Amir Goldstein wrote:
> > On Fri, May 11, 2018 at 1:41 PM, Eryu Guan <guaneryu@gmail.com> wrote:
> > > On Wed, May 09, 2018 at 07:22:48PM +0300, Amir Goldstein wrote:
> > >> On Wed, May 9, 2018 at 6:27 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > >> > Hi,
> > >> >
> > >> > Please find attached the V2 of the patch. Took care of Amir's comments
> > >> > from previous version.
> > >> >
> > >> > Add tests for metadata only copy up feature.
> > >> >
> > >> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > >>
> > >> Looks good.
> > >>
> > >> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > >
> > > Thanks for the review!
> > >
> > >>
> > >> Just a note to Eryu -
> > >>
> > >> You may want to hold on to this test until metacopy is merged
> > >> or at least staged on Miklos' next branch.
> > >
> > > I'd wait for the patches hit Miklos' tree.
> > >
> > 
> > Vivek,
> > 
> > This test seems to fail with overlayfs-next on check_file_blocks().
> > With ext4 underneath, blocks count is bigger than expected by 8 sectors.
> > With xfs+reflink the blocks check also fails with different actual nr of blocks.
> > 
> > I think it is generally unreliable to try to compute nr of blocks
> > and fail the test if actual is different than computed.
> > Maybe just check that overlay nr blocks is as the actual lower nr of
> > blocks.
> 
> Hi Amir,
> 
> Ok, I will change test to only make sure lower blocks are same as overlay
> blocks for metacopy file.
> 
> But something strange is happening on ext4. I create a file and do stat
> on that it reports 40 blocks. After sleeping for 10 seconds, it reports
> 32 blocks on same file. Is this expected? I run following bash script
> on ext4 and I can reproduce the issue. Is this a bug in ext4?

Adding "xfs_io -c "fsync" $ext4file" after file creation fixes the
anomaly.

Vivek

> 
> Vivek
> 
> !/bin/bash
> ext4file="/mnt/test-ext4/testfile.txt"
> 
> 
> rm $ext4file >> /dev/null 2>&1
> echo "hello" >> $ext4file
> chmod 600 $ext4file
> xfs_io -c "falloc 0 16384" $ext4file
> stat $ext4file
> sleep 10
> stat $ext4file
> 
