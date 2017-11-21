From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 1/2] overlay/038: code cleanup
Date: Tue, 21 Nov 2017 15:18:26 +0800
Message-ID: <20171121071826.GN2749@eguan.usersys.redhat.com>
References: <20171120143410.23357-1-chandan@linux.vnet.ibm.com>
 <CAOQ4uxg7HwRQ8P5ywrfq=s4NTDRavinoX3BMNyWOBQL9Pj6n-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg7HwRQ8P5ywrfq=s4NTDRavinoX3BMNyWOBQL9Pj6n-A@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Nov 21, 2017 at 08:33:53AM +0200, Amir Goldstein wrote:
> On Mon, Nov 20, 2017 at 4:34 PM, Chandan Rajendra
> <chandan@linux.vnet.ibm.com> wrote:
> > This commit implements similar changes made to overlay/041 test i.e.
> > - Remove duplicate merged dir tests
> > - Remove duplicate pure upper dir inside merged dir tests
> > - Sort out comments and error messages
> >
> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> 
> Looks good and tested.
> 
> Nit: one trailing whitespace in this patch.
> Applying: overlay/038: code cleanup
> .git/rebase-apply/patch:114: trailing whitespace.
> 
> warning: 1 line adds whitespace errors.

I can fix that up on commit. Thanks for the review!

Eryu
