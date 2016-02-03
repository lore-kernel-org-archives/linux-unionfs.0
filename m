From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH] ovl: ignore lower entries when checking purity of
 non-directory entries
Date: Wed, 3 Feb 2016 07:24:48 -0500
Message-ID: <20160203122448.GA849@redhat.com>
References: <145424627339.27058.6895511767458306300.stgit@zurg>
 <20160201141424.GA1448@redhat.com>
 <CALYGNiMzEHR3pfSr8cNhRyqS_4=QNOrNjtL69bpGuf6CiBJ5vw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CALYGNiMzEHR3pfSr8cNhRyqS_4=QNOrNjtL69bpGuf6CiBJ5vw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Konstantin Khlebnikov <koct9i@gmail.com>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Mon, Feb 01, 2016 at 06:43:19PM +0300, Konstantin Khlebnikov wrote:

[..]
> > Hi Konstantin,
> >
> > Thanks for the patch. This patch works for me also does not break
> > unionmount-testsuite.
> 
> Interesting. I haven't heard about this testsuite. Never read Documentation. =)
> 
> I've send couple of patches for xfstests: this case and fixed bugs in setattr.
> This seems much better place for them.

I guess running xfstests on overlayfs makes sense too, in an attempt to
figure out how overyalfs behavior is different from non layerd file
systems like xfs, ext4 etc and how many of those differences can be
fixed. 

Thanks
Vivek
