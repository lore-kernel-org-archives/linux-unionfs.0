From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] ovl: handle ENOENT on index lookup
Date: Fri, 20 Oct 2017 13:37:12 +0200
Message-ID: <20171020113712.GB699@kroah.com>
References: <1508497270-27971-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1508497270-27971-1-git-send-email-amir73il@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, "# v4 . 13" <stable@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Fri, Oct 20, 2017 at 02:01:10PM +0300, Amir Goldstein wrote:
> Fixes: 359f392ca53e ("ovl: lookup index entry for copy up origin")
> Cc: <stable@vger.kernel.org> # v4.13
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Why is there no changelog at all?  Not good, especially for a patch
wanting to be sent to the stable trees :(

thanks,

greg k-h
