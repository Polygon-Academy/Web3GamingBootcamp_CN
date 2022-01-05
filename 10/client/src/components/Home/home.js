import React from 'react';
import {Image} from 'antd';
import './index.css';

import Logo01 from '../../assets/Witness_01.png';
import B1Ima from '../../assets/B1Ima.png';
import B2Ima from '../../assets/B2Ima.png';
import B3Ima from '../../assets/B3Ima.png';
import B4Ima from '../../assets/B4Ima.png';
import B5Ima from '../../assets/B5Ima.png';

function Home(){
    return <div className="container">
        <div className="bodyG">
            <div className="bodylogoP">
            <Image preview={false} className="bodylogo" width={400}
            src={Logo01}
            />
            </div>
            <div className="bodyfont1">
            <span className="bodyfont1span">Witness love between you and her/him</span>
            </div>
            <span className="bodyfont2">
            We are a community to witness the love between all couples by giving unique NFT to the unique you.
            </span>
            <div className="BIma">
            <span className="BImaSpan">Follow us</span>
            <div className="BImaBox">
            <Image preview={false} 
            width={40} 
            src={B1Ima}
            />
            </div>
            <div className="BImaBox">
            <Image preview={false} 
            width={40} 
            src={B2Ima}
            />
            </div>
            <div className="BImaBox">
            <Image preview={false} 
            width={40} 
            src={B3Ima}
            />
            </div>
            <div className="BImaBox">
            <Image preview={false} 
            width={40} 
            src={B4Ima}
            />
            </div>
            <div className="BImaBox">
            <Image preview={false} 
            width={40} 
            src={B5Ima}
            />
            </div>
            </div>
        </div>
    </div>;
}
export default Home;