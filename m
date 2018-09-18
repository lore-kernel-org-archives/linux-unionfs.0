From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 1/4] ovl: fix memory leak on unlink of indexed file
Date: Tue, 18 Sep 2018 18:14:35 +0300
Message-ID: <CAOQ4uxjA8azLjyGd5A7KMg=fQ0dN1WacCA_zQG6Ac31ZjBVcHg@mail.gmail.com>
References: <20180918133434.27437-1-amir73il@gmail.com> <20180918133434.27437-2-amir73il@gmail.com>
 <20180918135937.GA25757@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20180918135937.GA25757@kroah.com>
Sender: stable-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, stable <stable@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Sep 18, 2018 at 4:59 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Sep 18, 2018 at 04:34:31PM +0300, Amir Goldstein wrote:
> > Fixes: caf70cb2ba5d ("ovl: cleanup orphan index entries")
> > Cc: <stable@vger.kernel.org> # v4.13
> > Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> > ---
> >  fs/overlayfs/util.c | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
>
> I know I reject patches without any changelog text present.  Maybe
> Miklos is more forgiving than me... :)
>

Well, I did not intend to CC stable at this point, but since I did and since
you chimed in, Miklos, feel free to add to commit message:

The memory leak was detected by kmemleak when running xfstests
overlay/051,053

Thanks,
Amir.
