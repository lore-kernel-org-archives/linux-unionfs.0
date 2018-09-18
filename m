From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 1/4] ovl: fix memory leak on unlink of indexed file
Date: Tue, 18 Sep 2018 15:59:37 +0200
Message-ID: <20180918135937.GA25757@kroah.com>
References: <20180918133434.27437-1-amir73il@gmail.com>
 <20180918133434.27437-2-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180918133434.27437-2-amir73il@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Tue, Sep 18, 2018 at 04:34:31PM +0300, Amir Goldstein wrote:
> Fixes: caf70cb2ba5d ("ovl: cleanup orphan index entries")
> Cc: <stable@vger.kernel.org> # v4.13
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/util.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

I know I reject patches without any changelog text present.  Maybe
Miklos is more forgiving than me... :)

greg k-h
